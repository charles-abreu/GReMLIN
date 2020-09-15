from glob import glob
import json
from clustering import CountingMatrix, SVD, Clustering
import os
import numpy as np
from igraph import Graph

class GraphJson:
    # update group information in graph dict
    def set_group(self, graph_dataset,groups):
        for g in groups:
            graph_dataset[g]['group'] = str(groups[g] + 1)
    # read .graph files in a json format/ dict
    def get_json(self, graph_dir):
        file_list = glob(graph_dir + '*.graph')
        graph_dataset = {}
        for file in file_list:
            g_json = json.load(open(file))
            graph_dataset[int(g_json['id'])] = g_json
        return graph_dataset

    # read a gsp file and include string representation on graph .json
    def set_gsp(self, graph_dataset, gsp_file):
        with open(gsp_file) as in_file:
            for line in in_file:
                if line.startswith('t'):
                    graph_id = line.strip().split('#')[-1].strip()
                else:
                    graph_dataset[int(graph_id)]['string'] += line

    def update_json(self, graph_dir, gsp_file, groups):
        # graphs dict
        graph_dataset = self.get_json(graph_dir)
        self.set_gsp(graph_dataset, gsp_file)
        self.set_group(graph_dataset, groups)

        # update .graph files
        for G in graph_dataset:
            f_name = graph_dir + os.sep + graph_dataset[G]['pdbID'] + '.' + str(graph_dataset[G]["id"]) + '.graph'
            json.dump(graph_dataset[G], open(f_name, 'w'), indent=4)

    def json_to_graphml(self, graph_dir, out_dir):
        if not os.path.exists(out_dir):
            os.mkdir(out_dir)

        cabecalho = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\nxsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">"
        attribute1 = "<key id=\"d0\" for=\"node\" attr.name=\"nodetype\" attr.type=\"int\"/>"
        attribute2 = "<key id=\"d1\" for=\"edge\" attr.name=\"edgetype\" attr.type=\"int\"/>"
        attribute3 = "<key id=\"d2\" for=\"node\" attr.name=\"nodelabel\" attr.type=\"string\"/>"
        attribute4 = "<key id=\"d3\" for=\"edge\" attr.name=\"edgelabel\" attr.type=\"string\"/>"
        attribute5 = "<key id=\"d4\" for=\"edge\" attr.name=\"edgeDistance\" attr.type=\"int\"/>"

        undirectedGraphPart1 = "<graph id=\"";
        undirectedGraphPart2 = "\" edgedefault=\"undirected\">";

        # Load .json graph files
        fileNames = glob(graph_dir + '*.graph')
        graphs = []
        for file in fileNames:
            graphs.append(json.load(open(file)))

        for graph in graphs:
            f = open(out_dir + os.sep + graph['pdbID'] + '.' + str(graph['id']) + '.xml', 'w')

            stringGraph = cabecalho + "\n"
            stringGraph = stringGraph + attribute1 + "\n"
            stringGraph = stringGraph + attribute2 + "\n"
            stringGraph = stringGraph + attribute3 + "\n"
            stringGraph = stringGraph + attribute4 + "\n"
            stringGraph = stringGraph + attribute5 + "\n"
            stringGraph = stringGraph + undirectedGraphPart1 + str(graph['id']) + undirectedGraphPart2 + "\n"

            for node in graph['nodes']:
                outLinhaParte1 = "<node id=\"n" + str(node['index']) + "\">";
                outLinhaParte2 = "<data key=\"d0\">" + str(node['atomTypeInt']) + "</data>";
                outLinhaParte3 = "<data key=\"d2\">" + node['residueName'] + ':' + node['residueNumber'] + ':' + node['atomName'] + "</data>";
                outLinhaParte4 = "</node>";
                stringNode = outLinhaParte1 + "\n" + outLinhaParte2 + "\n" + outLinhaParte3 + "\n" + outLinhaParte4 + "\n"
                stringGraph = stringGraph + stringNode

            for i, edge in enumerate(graph['links']):
                outEdgeParte1 = "<edge id=\"e" + str(i) + "\" source=\"n" + str(edge['source']) + "\" target=\"n" + str(edge['target']) + "\">";
                outEdgeParte2 = "<data key=\"d1\">" + str(edge['interactionTypeInt']) + "</data>";
                outEdgeParte3 = "<data key=\"d3\">" + self.get_interaction_initials(edge['interactionType']) + "</data>";
                outEdgeParte4 = "<data key=\"d4\">" + str(edge['distance']) + "</data>";
                outEdgeParte5 = "</edge>";
                stringEdge = outEdgeParte1 + "\n" + outEdgeParte2 + "\n" + outEdgeParte3 + "\n" + outEdgeParte4 + "\n" + outEdgeParte5
                stringGraph = stringGraph + stringEdge + "\n"

            closeGraphml = "</graph>\n</graphml>"
            stringGraph = stringGraph + closeGraphml
            f.write(stringGraph)
            f.close()

    def get_interaction_initials(self, propertie):
        propertiesIni = {'aromatic':'AR', 'saltbridges':'SB', 'hydrophobic': 'HB', 'hydrogenbond':'HP', 'repulsive':'RP', 'dissulfeto':'DS' }
        properties = propertie.split('/')
        result = ''
        for prop in properties:
            if result == '':
                result = propertiesIni[prop]
            else:
                result = result + '/' +  propertiesIni[prop]
        return result

class SplitGroup:
    def __init__(self, project_dir):
        self.project_dir = project_dir

    def run(self, groups, graph_dir):
        # mappin between graph id and group graph id
        map_group = {}
        # graphs dict
        graph_dataset = GraphJson().get_json(graph_dir)

        groups_dir = self.project_dir + os.sep + 'groups/'
        if not os.path.exists(groups_dir):
            os.mkdir(groups_dir)

        group_len = {} #lenght of each group
        inner_group_map = {} # mapping between original ID and inner group ID
        g_list = [g+1 for g in set(groups.values())]

        for g in g_list:
            group_len[g] = 0
            inner_group_id = 0
            out_file = open(groups_dir + 'g' + str(g) + '.gsp', 'w')
            for graph in graph_dataset:
                if int(graph_dataset[graph]['group']) == g:
                    map_group[(g, inner_group_id)] = graph_dataset[graph]['id']
                    out_file.write("t # " + str(inner_group_id) + '\n' +  graph_dataset[graph]['string'])
                    group_len[g] += 1
                    inner_group_id += 1
            out_file.close()
        return group_len, map_group

class Gspan:
    def __init__(self, gsp_dir):
        self.gsp_dir = gsp_dir

    def prime_factors(self, n):
        i = 2
        factors = []
        while i * i <= n:
            if n % i:
                i += 1
            else:
                n //= i
                factors.append(i)
        if n > 1:
            factors.append(n)
        return factors

    def get_propertie_str(self, propertie):
        types = { 2:'acceptor', 3:'aromatic', 5:'donor', 7:'hydrophobic', 11:'positive', 13:'negative',
            17:'aromatic', 19:'saltbridges', 23:'hydrophobic', 29:'hydrogenbond', 31:'repulsive'}

        primes = self.prime_factors(propertie)
        propretieList = []
        stringPropertie = ''

        for prime in primes:
            propretieList.append(types[prime])

        propretieList.sort()
        for typ in propretieList:
            if stringPropertie == '':
                stringPropertie = typ
            else:
                stringPropertie = stringPropertie + '/' + typ

        return stringPropertie

    def maximal_to_jason(self, maximal_file, map_group, pattern_dir):
        support = "0." + os.path.basename(maximal_file).split('.')[-3]
        group =  os.path.basename(maximal_file).split('_')[0][1:]
        patterns = {}
        graphID = ''

        with open(maximal_file) as in_file:
            for line in in_file:
                if line.startswith('t'):
                    graphID = line.strip().split('#')[-1].strip()
                    graphID = graphID.split('*')[0].strip()
                    patterns[graphID] = {'nodes':[], 'links':[],
                        'graphproperties' :{ 'inputgraphs' : []},
                        'group':group, 'support':support, 'id':graphID}
                elif line.startswith('v'):
                    v = line.split(' ')
                    patterns[graphID]['nodes'].append({
                        "index": int(v[1].strip()),
                        "atomType" : self.get_propertie_str(int(v[2].strip())),
                        "atomTypeInt" : v[2].strip()
                    })
                elif line.startswith('e'):
                    e = line.split(' ')
                    patterns[graphID]['links'].append({
                        "source" : int(e[1].strip()),
                        "target" : int(e[2].strip()),
                        "interactionType" : self.get_propertie_str(int(e[3].strip())),
                        "interactionTypeInt" : e[3].strip()
                    })
                elif line.startswith('x'):
                    x = line.strip().split(' ')
                    x = x[1:]
                    xInt = []
                    for elem in x:
                        xInt.append(int(elem.strip()))
                    nodeMap = []
                    for n in xInt:
                        nodeMap.append(map_group[(int(group), n)])
                    patterns[graphID]['graphproperties']['inputgraphs'] = nodeMap

        for pattern in patterns:
            new_file = pattern_dir + os.sep + os.path.basename(maximal_file) +'.patternIndex' + str(pattern) + '.json'
            with open(new_file, 'w') as out_file:
                json.dump(patterns[pattern], out_file, indent=4)

    def save_patterns(self, pattern_dir, map_group):
        if not os.path.exists(pattern_dir):
            os.mkdir(pattern_dir)

        file_names = glob(self.gsp_dir + "*.maximal.fp")
        for file in file_names:
            self.maximal_to_jason(file, map_group, pattern_dir)

    def run(self, supports, group_len, map_group):
        for g in group_len:#group_len:
            # g must have more than one graph
            if group_len[g] > 1:
                for sup in supports:
                    sup_formatted = '%.2f' % sup
                    if sup_formatted[-1] == '0':
                        sup_formatted = sup_formatted[:-1]
                    group_file =  self.gsp_dir + os.sep + "g" + str(g) + '.gsp'
                    print(group_file)
                    os.system('./gSpan -f ' + group_file + ' -s ' + sup_formatted + ' -o ' + ' -i ')
                    os.system('./filter ' + group_file + '.fp ' + group_file.replace('.gsp', '_' + sup_formatted + '.maximal.fp'))
                    os.rename(group_file + '.fp', group_file.replace(".gsp", '_' + sup_formatted + '.fp'))
            else:
                # escreve grafo diretamente como padrao
                for sup in supports:
                    supFormatted = '%.2f' % sup
                    # Retira zero em cazo de uma casa decimal apenas
                    if supFormatted[-1] == '0':
                    	supFormatted = supFormatted[:-1]
                    group_file =  self.gsp_dir + os.sep + "g" + str(g) + '.gsp'
                    newName = group_file.replace(".gsp", '_' + supFormatted + '.maximal.fp')
                    f = open(group_file)
                    out = open(newName, 'w')
                    for line in f:
                    	if line.startswith('t'):
                    		line = line.strip() + ' * 1\n'
                    	out.write(line)
                    out.write('x 0')
                    f.close()
                    out.close()

class MapPattern:
    def __init__(self, support_dir):
        self.support_dir = support_dir

        if not os.path.exists(self.support_dir):
            os.mkdir(self.support_dir)

    def get_igraph(self,graph):
        label_map = {}
        for node in graph['nodes']:
            label_map[node['index']] = node['atomTypeInt']
        node_list = list(label_map.keys())
        node_list.sort()

        label_node = []
        for node in node_list:
            label_node.append(int(label_map[node]))
        # create igraph object
        pattern_edges = []
        label_map = {} # mapping (source,target) in its label
        for link in graph['links']:
            source = int(link['source'])
            target = int(link['target'])
            pattern_edges.append((source, target))
            label_map[(source, target)] = int(link['interactionTypeInt'])
        new_graph = Graph(pattern_edges)
        # get edge label list
        label_map_2 = {}
        for edge in pattern_edges:
            source = edge[0]
            target = edge[1]
            label_map_2[new_graph.get_eid(source, target)] = label_map[(source, target)]
        label_edge = []
        for edge in label_map_2:
            label_edge.append(label_map_2[edge])

        return new_graph, label_node, label_edge

    def get_graph(self, graphs_dir):
        file_list = glob(graphs_dir + '*.graph')
        graphs = []
        for file in file_list:
            graphs.append(json.load(open(file)))
        return graphs

    def get_paterns(self, pattern_dir):
        file_list = glob(pattern_dir + '*.json')
        patterns = []
        for file in file_list:
            patterns.append(json.load(open(file)))
        return patterns

    def run(self, supports, group_len, graphs_dir, pattern_dir, ):

        for sup in supports:
            supFormatted = '%.2f' % sup
            # Retira zero em cazo de uma casa decimal apenas
            if supFormatted[-1] == '0':
                supFormatted = supFormatted[:-1]
            newDirec = self.support_dir + os.sep + 'json_' + supFormatted + os.sep
            if not os.path.exists(newDirec):
                os.mkdir(newDirec)

        graph_data = self.get_graph(graphs_dir)
        patterns_data = self.get_paterns(pattern_dir)
        groups = list(group_len.keys())
        for sup in supports:
            supFormatted = '%.2f' % sup
            # Retira zero em cazo de uma casa decimal apenas
            if supFormatted[-1] == '0':
                supFormatted = supFormatted[:-1]
            for group in groups:
                for graph in graph_data:
                    if int(graph['group']) == group:
                        # graph, node labels, edge labels to verify isomorphism
                        super_graph, super_label_node, super_label_edge = self.get_igraph(graph)
                        # update graphs
                        file_name = self.support_dir + 'json_' + supFormatted + os.sep + 'g' + str(group) + '.' + str(graph['pdbID'])+ '.' + str(graph['id']) + '.graph.json'
                        with open(file_name, 'w') as in_file:
                            json.dump(graph, in_file, indent=4)

                        for pattern in patterns_data:
                            # if pattern in this group
                            if int(pattern['group']) == group and pattern['support'] == supFormatted:
                                # pattern, node labels, edge labels to verify isomorphism
                                sub_graph, sub_label_node, sub_label_edge = self.get_igraph(pattern)
                                # subgraph isomorphism
                                itsaMatch = super_graph.subisomorphic_vf2(sub_graph, color1=super_label_node, color2=sub_label_node,
                                    edge_color1=super_label_edge,edge_color2=sub_label_edge, return_mapping_12=False,
                                    return_mapping_21=False, callback=None, node_compat_fn=None, edge_compat_fn=None)
                                if itsaMatch:
                                    graph_aux = json.load(open(file_name))
                                    # get list with mapping betwenn pattern and original graph
                                    mapping = super_graph.get_subisomorphisms_vf2(sub_graph, color1=super_label_node, color2=sub_label_node,
    									edge_color1=super_label_edge, edge_color2=sub_label_edge, node_compat_fn=None, edge_compat_fn=None)
                                    # set of node in the pattern
                                    mappedVertices = set()
                                    mappedEdges = set()

                                    for mapp in mapping:
                                        mappedVertices = mappedVertices.union(set(mapp))
                                    # if the node is in the pattern, receive the pattern ID
                                    for node in graph_aux['nodes']:
                                        if node['index'] in mappedVertices:
                                            patternID = int(pattern['id'])
                                            node['patterns'].append(patternID)
                                    # mapping pattern edges in the original graph
                                    patternEdgeList = sub_graph.get_edgelist()
                                    for e in patternEdgeList:
                                        for m in mapping:
                                            # insert mapped edges
                                            mappedEdges.add((m[e[0]], m[e[1]]))
                                    # If the pattern contain the edge, the edges receis the pattern ID
                                    for edge in graph_aux['links']:
                                        source = edge['source']
                                        target = edge['target']
                                        if ((source, target) in mappedEdges) or ((target, source) in mappedEdges):
                                            index = int(pattern['id'])
                                            edge['patterns'].append(index)
                                    with open(file_name, 'w') as out_file:
                                        json.dump(graph_aux, out_file, indent=4)


if __name__ == '__main__':
    gsp = 'test/out/graph_dataset.gspan'
    # support to run gspan
    supports = np.arange(0.1, 0.9, 0.1)
    X = CountingMatrix('test/out/graphs/').run(False)
    X2 = SVD().run(X)
    groups = Clustering().run(X2, X.index)
    #GraphJson().update_json('test/out/graphs/', gsp, groups)
    gl, mg = SplitGroup('test/out/').run(groups, 'test/out/graphs/')
    #Gspan('test/out/groups/').run(supports, gl, mg)
    #Gspan('test/out/groups/').save_patterns('test/out/patterns/', mg)
    MapPattern('test/out/supports/').run(supports, gl,'test/out/graphs/', 'test/out/patterns/')
