#-----------------------------------------------------------------
# Contact Data
# Compute the atoms interactions types and create the .ctc files
# with the information of the interactions
#-----------------------------------------------------------------
def contactData(datasetDir, cutoffs):
	graphNumber = 0
	datasetGsp = open(datasetDir + 'inDatasetGraphs.gspan', 'w')
	#Convers ligands from .pdb to .mol
	fileList = glob(datasetDir+'*.pdb')
	fileList.sort()
	for fileName in fileList:
		atoms = {} #dict com átomos do arquivo
		#Open pdb file
		pdbFile = open(fileName, 'r')
		for line in pdbFile:
			recordName = tools.getRecordName(line) #get the record name line
			# Dont get H2O lines and ligands in artifact list
			if((recordName == 'ATOM') or (recordName == 'HETATM')):
				atomSerial = int(line[6:11].strip())
				atoms[atomSerial] = {"id" : line[6:11].strip(),
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
		pdbFile.close()
		# Setting ligand atoms properties
		# Get ligand file names from current pdb file
		ligandFileList = glob(fileName[:-4] + '*.lig') # -4 pra retirar .pdb
		for ligand in ligandFileList:
			properties =  tools.getPmapperProperties(ligand + '.pmapper')
			numberOfAtons = 0

			infile = open(ligand, 'r')
			for line in infile:
				atomSerial = int(line[6:11].strip())
				#  Set atom properties
				atoms[atomSerial]["atomPropertie"] = properties[numberOfAtons]
				numberOfAtons = numberOfAtons + 1
			infile.close()
		# Setting protein atoms properties
		residuesProperties = tools.getResidueProperties()

		for atom in atoms:
			residueName = atoms[atom]['residueName']
			atomName = atoms[atom]['atomName']
			keyPropertie = residueName + '_' + atomName
			# Must be ATOM, not HET
			if atoms[atom]['pdbType'] == 'ATOM':
				if keyPropertie in residuesProperties:
					atoms[atom]["atomPropertie"] = residuesProperties[keyPropertie]
				#Carbonos alpha nao tem propriedades especificadas nos arquivos
				else:
					atoms[atom]["atomPropertie"] = 'null'
		# ------------------------------------------------------------------------------------------
		# Fazendo calculo de contatos

		edges = calculaDT(fileName) # obtendo arestas
		print(fileName)

		#################################################
		# Criando grafos
		################################################

		interactions = getContactInteractions(atoms, edges, cutoffs) # calculando interaoes

		# Computando componentes conexas
		# Each componnet is a Adj. List {atom : atomList}
		connectedComponents = getConnectedComponents(interactions)


		for component in connectedComponents:
			# Criando grafos json
			createGraphsJson(atoms, component, interactions, fileName, graphNumber, datasetDir)
			# Create gspan
			createGraphsGspan(atoms, component, interactions, datasetGsp, graphNumber)
			graphNumber = graphNumber + 1

	datasetGsp.close()
		# .ctc files
		#generateCtc(atoms, edges, fileName)
