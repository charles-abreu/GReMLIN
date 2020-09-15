## -*- coding: latin-1 -*-
#-----------------------------------------------------------------------
# Developed by Charles Abreu Santana
# 07/01/2018
#-----------------------------------------------------------------------
import os
from glob import glob
import numpy as np
import math
from scipy.spatial import Delaunay
import json

class Modeling:
	def __init__(self, data_dir, graph_dir, out_dir):
		self.data_dir = data_dir
		self.out_dir = out_dir
		self.graph_dir = graph_dir
		if not os.path.exists(graph_dir):
			os.mkdir(graph_dir)

	def run(self, atom_cut, val_lig):
		prot_dir = self.out_dir + os.sep + 'receptor/'
		if not os.path.exists(prot_dir):
			os.mkdir(prot_dir)
		lig_dir = self.out_dir + os.sep + 'ligands/'
		if not os.path.exists(lig_dir):
			os.mkdir(lig_dir)

		print('Spliting pdb files in chains ...')
		SplitChain(self.data_dir).save(prot_dir)

		print('Extrcting relevant ligands ...')
		ComputeLigand(prot_dir, atom_cut, val_lig).save(lig_dir)

		print('Computing properties ...')
		Properties(lig_dir).run_babel()
		Properties(lig_dir).run_pmapper()

		print('Computing contacts ...')
		ContactData(self.out_dir, prot_dir, lig_dir, self.graph_dir).run()
#-------------------------------------------
# Compute Split Chain
# Split .pdb files in terms of its chains.
#-------------------------------------------
class SplitChain():
	def __init__ (self, data_dir):
		self.file_list = glob(data_dir + os.sep +'*.pdb') # path with .pdb files

	def split_in_chains(self, pdb_file):
		chains = {} # group lines by chain
		with open(pdb_file) as in_file:
			for line in in_file:
				record_name = line[:6].strip() #
				if record_name in ['ATOM','HETATM']:
					chain = line[21]
					# Ignore Hydrogen and water lines
					if line[76:78].strip() == 'H' or line[17:20].strip() == 'HOH':
						continue
					if chain in chains:
						chains[chain] += line # concatenate lines
					else:
						chains[chain] = line # new chain
		return chains

	def save(self, out_dir):
		for pdb_file in self.file_list:
			# lines grouped by chains
			chains = self.split_in_chains(pdb_file)
			for chain in chains:
				pdb_id = os.path.basename(pdb_file).split('.')[0] # Uses file name as ID
				file_name = out_dir + os.sep + pdb_id.upper() + "." + chain + ".pdb"
				with open(file_name, "w") as out_file:
					out_file.write(chains[chain])

#--------------------------------------------
# Compute Ligand
# Finds valid ligans and build files to it.
#--------------------------------------------
class ComputeLigand():
	def __init__(self, data_dir, art_len, valid_ligands):
		self.file_list = glob(data_dir +'*.pdb')
		self.artifact_set = self.get_artifact() #Artifact list
		self.artifact_len = art_len
		self.valid_ligands = valid_ligands
	# Gete artifact list from config files
	def get_artifact(self):
		with open("config/artifacts.dat") as in_file:
			return set([line.strip() for line in in_file])

	def get_ligands(self, pdb_file):
		ligands = {}
		with open(pdb_file) as in_file:
			for line in in_file:
				if line[:6].strip() == 'HETATM':
					ligName = line[17:20].strip()
					if self.valid_ligands:
						if (not ligName in self.artifact_set) and (ligName in self.valid_ligands):
							#Ligand name plus ligand sequence number
							ligand_name = ligName + '_' + line[22:26].strip() + '_' + line[21]
							if ligand_name in ligands:
								ligands[ligand_name] += line
							else:
								ligands[ligand_name] = line
					else: # there is not valid ligands
						if (not ligName in self.artifact_set):
							#Ligand name plus ligand sequence number
							ligand_name = ligName + '_' + line[22:26].strip() + '_' + line[21]
							if ligand_name in ligands:
								ligands[ligand_name].append(line)
							else:
								ligands[ligand_name] = [line]
		return ligands

	def save(self, out_dir):
		for pdb_file in self.file_list:
			pdb_id = os.path.basename(pdb_file).split('.')[0] # Uses file name as ID
			chain = os.path.basename(pdb_file).split('.')[1]
			pdb_id = pdb_id + "." + chain

			ligands = self.get_ligands(pdb_file)
			for lig in ligands:
				if len(ligands[lig]) >= self.artifact_len:
					file_name = out_dir + os.sep + pdb_id + "." + lig + ".lig" #extension .lig
					with open(file_name, "w") as out_file:
						out_file.write("".join(ligands[lig]))

#--------------------------------------------------
# Get Properties
# Compute properties to atom ligands using Pmapper
#--------------------------------------------------
class Properties:
	def __init__(self, lig_dir):
		#environ to Chemaxon license
		os.environ["CHEMAXON_LICENSE_URL"] = 'config/Chemaxon/license.cxl'
		self.lig_dir = lig_dir

	def run_babel(self):
		file_list = glob(self.lig_dir + '*.lig')
		for lig_file in file_list:
			os.system("obabel -i pdb " + lig_file + " -o mol -O" + lig_file + ".mol")

	def run_pmapper(self):
		mol_list = glob(self.lig_dir + '*.mol')
		for mol_file in mol_list:
			os.system("config/Chemaxon/bin/pmapper -c config/pharma-calc.xml " +
				mol_file + " > " + mol_file.replace(".mol", ".pmapper"))

class Protein:
	def __init__(self, pdb_file):
		self.pdb_file = pdb_file
		self.pdb_id = os.path.basename(pdb_file).split(".")[0] + "." + os.path.basename(pdb_file).split(".")[1]
	def get_id(self):
		pdb = os.path.basename(self.pdb_file).split('.')[0]
		chain = os.path.basename(self.pdb_file).split('.')[1]
		return pdb + "." + chain
	# atoms data of the pdb file
	def get_atoms(self):
		atoms = {} #dict com átomos do arquivo
		with open(self.pdb_file) as in_file:
			for line in in_file:
				record_name = line[:6].strip()
				if record_name in ["ATOM", "HETATM"]:
					atom_serial = int(line[6:11].strip())
					atoms[atom_serial] = {"id" : line[6:11].strip(),
						"pdbType": line[:6].strip(),
						"chain": line[21],
						"atomName" : line[12:16].strip(),
						"residueName" : line[17:20].strip(),
						"residueNumber": line[22:26].strip(),
						"residueIndex" : line[22:26].strip(),
						"symbol": line[76:78].strip(),
						"atomPropertie" : "null",
						"x" : float(line[30:38].strip()),
						"y" : float(line[38:46].strip()),
						"z" : float(line[46:54].strip())}
		return atoms

	# get x,y,z coordinates of the atoms
	def get_coord(self):
		min_coord = 0.0 # min value to translation
		all_coords = []
		with open(self.pdb_file) as in_file:
			for line in in_file:
				record_name = line[:6].strip()
				if record_name in ["ATOM", "HETATM"]:
					# extract the coordinates
					xyz = [int(line[6:11].strip()),
						float(line[30:38].strip()),
						float(line[38:46].strip()),
						float(line[46:54].strip())]
					all_coords.append(xyz)
					# verify min coord
					if xyz[1] < min_coord:
						min_coord = xyz[1]
					elif xyz[2] < min_coord:
						min_coord = xyz[2]
					elif(xyz[3] < min_coord):
						min_coord = xyz[3]
		if min_coord < 0.0:
			min_coord *= -1.0

		for xyz in all_coords:
			xyz[1] += min_coord + 1.000
			xyz[2] += min_coord + 1.000
			xyz[3] += min_coord + 1.000

		return all_coords

class Triangulation:
	def __init__(self, protein):
		self.coords = protein.get_coord()
	# Compute edges using Delaunay Triangulation
	def run(self):
		list_points = [] # [x, y, z]
		count = 0 #atom number Delaunay
		map = {} #map Delaunay number -> PDB number
		for coord in self.coords:
			map[count] = coord[0]
			list_points.append([coord[1], coord[2], coord[3]]) #x,y,z
			count += 1

		points = np.array(list_points)
		tgl = Delaunay(points) #Delaunay triangulation

		set_of_edges = set()
		for triangle in tgl.simplices:
			edges = self.combination(triangle) #extract edges from triangle
			for e in edges:
				set_of_edges.add(e)

		list_of_edges = list(set_of_edges)
		list_of_edges.sort()

		new_edges = []
		for edge in list_of_edges:
			new_edges.append((map[edge[0]], map[edge[1]]))
		return new_edges
	# Combination of elements from double list (edges of the triangulation)
	def combination(self, triangle):
		result = []
		count = 1
		for elem in triangle:
			for second_elem in triangle[count:]:
				if(elem < second_elem):
					result.append((elem, second_elem))
				else:
					result.append((second_elem, elem))
			count += 1
		return result

class Interaction:
	def __init__(self, cutoffs):
		self.cutoffs = cutoffs
	# get interaction type and distance to the edges
	def compute_contacts(self, atoms, edges):
		validEdges = {}
		for edge in edges:
			source = edge[0]
			target = edge[1]
			if atoms[source]['pdbType'] != atoms[target]['pdbType']:
				interaction = self.get_interaction(atoms[source], atoms[target])
				if interaction != 'null':
					validEdges[(source,target)] = (interaction, self.distance(atoms[source], atoms[target]))
		return validEdges

	# Compute interaction type between two atoms
	def get_interaction(self, atom1, atom2):
		dist = self.distance(atom1, atom2) # euclidian distance between two atoms
		atomType1 = atom1['atomPropertie'].split('/')
		atomType2 = atom2['atomPropertie'].split('/')
		propertieList = []
		if (('aromatic' in atomType1) and ('aromatic' in atomType2)) and (dist >= self.cutoffs["aromatic-stacking-min"]) and (dist <= self.cutoffs["aromatic-stacking-max"]):
			propertieList.append('aromatic')
		if ((('donor' in atomType1) and (('acceptor' in atomType2)) or (('donor' in atomType2)) and ('acceptor' in atomType1))) and (dist >= self.cutoffs["hydrogen-bond-min"]) and (dist <= self.cutoffs["hydrogen-bond-max"]):
			propertieList.append('hydrogenbond')
		if ('hydrophobic' in atomType1) and ('hydrophobic' in atomType2) and (dist >= self.cutoffs["hydrofobic-min"]) and (dist <= self.cutoffs["hydrofobic-max"]):
			propertieList.append('hydrophobic')
		if ((('negative' in atomType1)  and ('negative' in atomType2)) or (('positive' in atomType1)  and ('positive' in atomType2))) and (dist >= self.cutoffs["repulsive-min"]) and (dist <= self.cutoffs["repulsive-max"]):
			propertieList.append('repulsive')
		if ((('positive' in atomType1)  and ('negative' in atomType2 )) or (('negative' in atomType1)  and ('positive' in atomType2))) and (dist >= self.cutoffs["salt-bridge-min"]) and (dist <= self.cutoffs["salt-bridge-max"]):
			propertieList.append('saltbridges')
		if propertieList == []:
			return 'null'
		propertieList.sort()
		propertie = ''
		for prop in propertieList:
			if propertie == '':
				propertie = prop
			else:
				propertie = propertie +	'/' + prop
		return propertie

	# Compute euclidian distance between two atoms
	# atom = dict[atomSerial] -> {'record' : information}
	def distance(self, atom1, atom2):
		return math.sqrt(math.pow((atom1['x']-atom2['x']), 2) +
			math.pow((atom1['y']-atom2['y']), 2) +
			math.pow((atom1['z']-atom2['z']), 2))

class ConnectedComponets:
	def __init__(self, edges):
		self.edges = edges
	# Create Adj list from set of edges
	def get_adj_list(self):
		graph = {}
		edgeList = list(self.edges.keys())
		for edge in edgeList:
			source = edge[0]
			target = edge[1]

			if source in graph:
				graph[source].add(target)
			else:
				graph[source] = set()
				graph[source].add(target)

			if target in graph:
				graph[target].add(source)
			else:
				graph[target] = set()
				graph[target].add(source)
		return graph
	# Compute connected components using bfs
	def run(self):
		adjList = self.get_adj_list()
		nodes = list(adjList.keys())
		checklist = {}
		numComponente = 0

		for n in nodes:
			checklist[n] = -1

		for  vertex in adjList:
			if checklist[vertex] == -1:
				numComponente = numComponente + 1
				self.bfs(adjList, vertex, checklist, numComponente)

		components = []
		for i in range(1, (numComponente+1)):
			g = {}
			for v in checklist:
				if checklist[v] == i:
					g[v] = adjList[v] # Lista de Adj de v
			components.append(g)
		return components

	#  Breadth first search
	def bfs(self, graph, vertex, checklist, numComponente):
		checklist[vertex] = numComponente
		for u in graph[vertex]:
			if  checklist[u] == -1:
				self.bfs (graph, u, checklist, numComponente)

class GraphFile:
	def __init__(self, atoms, component, interactions):
		self.atoms = atoms
		self.component = component
		self.interactions = interactions

	def get_propertie_int(self, propertie, labelType):
		atomTypes = {'acceptor':2, 'aromatic':3, 'donor':5, 'hydrophobic':7, 'positive':11, 'negative':13}
		interactionTypes = {'aromatic':17, 'saltbridges':19, 'hydrophobic': 23, 'hydrogenbond':29, 'repulsive':31}

		number = 1
		if labelType == 'node':
		    properties = propertie.split('/')
		    for prop in properties:
		        number = number * atomTypes[prop]
		    return number
		else:
		    properties = propertie.split('/')
		    for prop in properties:
		        number = number * interactionTypes[prop]
		    return number
		return
	# get set of edges from Adj. list
	def get_edges(self):
		s = set()
		for v in self.component:
			for u in self.component[v]:
				if v < u:
					s.add((v,u))
				else:
					s.add((u,v))
		return s
	# Write .gsp file
	def create_gspan(self, out_file, graph_number):
		out_file.write("t # " + str(graph_number) + '\n')
		node_list = list(self.component.keys())
		node_list.sort()

		map = {}
		number_node = 0
		for node in node_list:
			map[node] = number_node
			out_file.write("v " + str(number_node) + " " +
				str(self.get_propertie_int(self.atoms[node]["atomPropertie"], 'node')) + '\n');
			number_node += 1
		componnent_edges = list(self.get_edges())
		componnent_edges.sort()

		for edge in componnent_edges:
			out_file.write("e " + str(map[edge[0]]) + " " + str(map[edge[1]])
				+ " " + str(self.get_propertie_int(self.interactions[edge][0], 'link')) + '\n')

	def create_json(self, graph_number, protein, graph_dir):
		graph_json = {"nodes":[],"links":[], "id":graph_number, "string":"", "group":""}
		number_node = 0
		map = {}
		color = ""

		node_list = list(self.component.keys())
		node_list.sort()

		for node in node_list:
			map[node] = number_node
			if self.atoms[node]["pdbType"] == "ATOM":
				color = "#7CB4BE"
				isLigand = False
			else:
				color = "#9BCE91"
				isLigand = True

			graph_json["nodes"].append({
				"patterns": [],
	 			"index": number_node,
	 			"chain": self.atoms[node]["chain"],
	 			"atomType" : self.atoms[node]["atomPropertie"],
	 			"atomTypeInt" : str(self.get_propertie_int(self.atoms[node]["atomPropertie"], 'node')),
	 			"atomName": self.atoms[node]["atomName"],
	 			"residueNumber": self.atoms[node]["residueNumber"],
	 			"residueName": self.atoms[node]["residueName"],
	 			"color": color,
	 			"isLigand": isLigand
			})
			number_node += 1

		componnent_edges = self.get_edges()
		for edge in componnent_edges:
			graph_json["links"].append({
				"patterns": [],
	 			"source" : map[edge[0]],
	 			"target" : map[edge[1]],
	 			"interactionType" : self.interactions[edge][0],
	 			"interactionTypeInt" :  self.get_propertie_int(self.interactions[edge][0], 'link'),
	 			"distance" : str(self.interactions[edge][1])
				})
		graph_json['pdbID'] = protein.get_id()
		# save .json
		file_name = graph_dir + os.path.basename(protein.pdb_file).replace('.pdb', '.' + str(graph_number) + '.graph')
		with open(file_name, 'w') as out_file:
			json.dump(graph_json, out_file, indent = 4)

class ContactData():
	def __init__(self, out_dir, pdb_dir, lig_dir, graph_dir):
		self.pdb_dir = pdb_dir
		self.pdb_list = glob(pdb_dir + "*.pdb")
		self.pdb_list.sort()
		self.graph_dir = graph_dir
		self.lig_dir = lig_dir
		self.out_dir = out_dir
	# Reading pmapper files
	def get_pmapper_properties(self, pmapper_file):
		with open(pmapper_file) as in_file:
			line = in_file.readline()
			prop_1 = line.strip().split(';') # line with atom properties
			prop_2 = []

			for atom in prop_1:
				propretieList = []
				atomPropertie = ''
				# split properties
				types = atom.split('/')
				for typePropertie in types:
					if typePropertie == 'r':
						propretieList.append('aromatic')
					elif typePropertie == '+':
						propretieList.append('positive')
					elif typePropertie == '-':
						propretieList.append('negative')
					elif typePropertie == 'd':
						propretieList.append('donor')
					elif typePropertie == 'a':
						propretieList.append('acceptor')
					elif typePropertie == 'h':
						propretieList.append('hydrophobic')

				if len(propretieList) == 0:
					propretieList.append('null')
				propretieList.sort()
				for prop in propretieList:
					atomPropertie += prop + '/'
				# remove last backslash
				prop_2.append(atomPropertie[:-1])
		return prop_2
	# Get properties of the residues atons
	def get_residue_properties(self):
		with open("config/list_atom.dat") as in_file:
			atom_prop = {} # properties
			atom_type = ""
			for line in in_file:
				if line.startswith("#"):
					atom_type = line[1:].strip()
				else:
					atom_name = line.strip().replace(" ", "_")
					if not atom_name in atom_prop:
						atom_prop[atom_name] = atom_type
					else:
						atom_prop[atom_name] = atom_prop[atom_name] + "/" + atom_type
			for atom in atom_prop:
				atom_p = ""
				prop_list = atom_prop[atom].split('/') #list of properties
				prop_list.sort()
				for prop in prop_list:
					atom_p += prop + '/'
				atom_prop[atom] = atom_p[:-1]
		return atom_prop
	# include pmapper properties in atom dictinary
	def set_pmapper_properties(self, atoms, pdb_id, lig_dir):
		# Get ligand file names from current pdb file
		ligand_list = glob(lig_dir + pdb_id + '*.lig') # -4 pra retirar .pdb
		for lig_file in ligand_list:
			number_of_atoms = 0
			# setting properties for ligand atoms
			properties = self.get_pmapper_properties(lig_file + ".pmapper")
			with open(lig_file) as in_file:
				for line in in_file:
					atom_serial = int(line[6:11].strip())
					atoms[atom_serial]["atomPropertie"] = properties[number_of_atoms]
					number_of_atoms += 1
	# include residue properties in atom dictionary
	def set_residue_properties(self, atoms):
		# setting properties for residue atoms
		res_prop = self.get_residue_properties()
		for atom in atoms:
			residueName = atoms[atom]['residueName']
			atomName = atoms[atom]['atomName']
			keyPropertie = residueName + '_' + atomName
			# Must be ATOM, not HET
			if atoms[atom]['pdbType'] == 'ATOM':
				if keyPropertie in res_prop:
					atoms[atom]["atomPropertie"] = res_prop[keyPropertie]
				#Carbonos alpha nao tem propriedades especificadas nos arquivos
				else:
					atoms[atom]["atomPropertie"] = 'null'
	# Setting ligand atoms properties
	def set_properties(self, protein, graph_num, out_file):
		atoms = protein.get_atoms() # atoms information
		# Add properties information in atoms
		self.set_pmapper_properties(atoms, protein.pdb_id, self.lig_dir)
		self.set_residue_properties(atoms)
		# compute edges using Delaunay Triangulation
		edges = Triangulation(protein).run()
		# compute all valid interactions
		interactions = Interaction(read_cutoff()).compute_contacts(atoms, edges)
		connected_components = ConnectedComponets(interactions).run()
		# Each componnet is a Adj. List {atom : atomList}
		for component in connected_components:
			gf = GraphFile(atoms, component, interactions)
			gf.create_gspan(out_file, graph_num)
			gf.create_json(graph_num, protein, self.graph_dir)
			graph_num += 1

		return graph_num

	def run(self):
		with open(self.out_dir  + 'graph_dataset.gspan', 'w') as out_file:
			graph_number = 0
			for pdb_file in self.pdb_list:
				p = Protein(pdb_file)
				graph_number = self.set_properties(p, graph_number, out_file)

def read_cutoff():
	cutoffs = {}
	with open('config/cutoffs.dat') as in_file:
		for line in in_file:
			splittedLine = line.strip().split(",")
			cutoffs[splittedLine[0] + "-min"] = float(splittedLine[1])
			cutoffs[splittedLine[0] + "-max"] = float(splittedLine[2])
	return cutoffs

#################################
# Test
#################################
if __name__ == '__main__':
	Modeling('test/data/', 'test/out/').run(7, [])
