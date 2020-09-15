import pandas as pd
import os
from glob import glob
import json
from collections import deque
import numpy as np
from numpy.matlib import repmat
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score

class CountingMatrix:
    # Directory containing .graph files
    def __init__(self, data_dir):
        self.data_dir = data_dir
    # reading graphs from directory
    def get_graphs(self):
        graphs = {}
        # Reading graphs
        graph_list = glob(self.data_dir + "*.graph")
        for file in graph_list:
            graphs[file] = json.load(open(file))
        return graphs
    # dict with vertex properties
    def get_properties(self):
        # Each graph is a dict with its vertex and list of properties
        #{ graph : {v0:[p1], v1:[p1,p2,p3], vn:[p1,p2,pn]}}
        listProperties = {}
        graphs =  self.get_graphs()
        for graph in graphs:
            nodes = {}
            for node in graphs[graph]['nodes']:
                nodes[node['index']] = node['atomType'].split('/')
            listProperties[graphs[graph]['id']] = nodes
        return listProperties
    # dict with edges
    def get_edges(self):
        # Each graph is a list of vertex pairs
        # {graph:[(v0, v1), (v1, v2)]}
        edges = {}
        graphs =  self.get_graphs()
        for graph in graphs:
            edges[graphs[graph]['id']] = []
            for edge in graphs[graph]['links']:
                edges[graphs[graph]['id']].append((int(edge['source']), int(edge['target'])))
        return edges
    # Create a adj list from edges
    def get_adj_list(self, edge_list):
    	graph = {}
    	for edge in edge_list:
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
    # Run bfs for each vertex
    def get_graph_properties(self, graph, listProperties):
    	allProperties = {}
    	maxPath = 0
    	for node in graph:
    		nodeProperties, maxNodeLenght = self.bfs(graph, listProperties, node)
    		maxPath = max(maxPath, maxNodeLenght)

    		for prop in nodeProperties:
    			if prop in allProperties:
    				allProperties[prop] = allProperties[prop] + nodeProperties[prop]
    			else:
    				allProperties[prop] = nodeProperties[prop]

    	return allProperties, maxPath
    # BSF to compute strucural properties
    def bfs(self, graph, listNodes, node):
    	# Distancia em arestas entre node e demais atomos
    	d = {}
    	# Cada vertice possui uma lista de distancias
    	for n in graph:
    		d[n] = []
    	# Vertice de origem tem distancia zero
    	d[node].append(0)
    	# Cores dos vertices na busca
    	cores = {}
    	# Pinta vertices de branco
    	for v in graph:
    		cores[v] = 'white'
    	# Vertice inicial visitado
    	cores[node] = 'gray'

    	# Fila com nos visitados
    	queue = deque([node])

    	maxPath = 0

    	while queue:

    		u = queue.popleft()
    		#print('Para nodo ' + str(u))
    		for v in graph[u]:
    			#print("Visitou " + str(v))
    			if cores[v] == 'white':
    				for dist in d[u]:
    					maxPath = max(maxPath, dist + 1)
    					d[v].append(dist + 1)
    				cores[v] = 'gray'
    				queue.append(v)
    			elif cores[v] == 'gray':
    				aux = d[v][:]
    				for dist in d[u]:
    					maxPath = max(maxPath, dist + 1)
    					d[v].append(dist + 1)
    				for dist in aux:
    					maxPath = max(maxPath, dist + 1)
    					d[u].append(dist + 1)
    		cores[u] = 'black'

    	# Conta Tipos de propriedades
    	nodeProperties = {}

    	for v in d:
    		if v != node:
    			for prop1 in listNodes[node]:
    				for prop2 in listNodes[v]:
    					for dist in d[v]:
    						propName = str(prop1) + '-' + str(dist) + '-' +str(prop2)
    						if propName in nodeProperties:
    							nodeProperties[propName] = nodeProperties[propName] + 1
    						else:
    							nodeProperties[propName] = 1

    	return nodeProperties, maxPath
    # list graphs paths
    def list_properties(self):
        # vertex properties
        listProperties = self.get_properties()
        edges = self.get_edges()
        # generating graphs
        graphs = {}
        for graph in edges:
            graphs[graph] = self.get_adj_list(edges[graph])

        #graphID -> properties
        graphsProperties = {}
        maxPath = 0
        for g in graphs:
            #print(" Counting properties: Graph #"  + str(g) )
            gProperties, gLenght = self.get_graph_properties(graphs[g], listProperties[g])
            # Dicionario com os tipos de propriedades de cada grafo
            graphsProperties[g] = gProperties
            # Grafo de maior caminho
            maxPath = max(maxPath, gLenght)

        return maxPath, list(graphs.keys()), graphsProperties
    # Enumerate all possible paths
    def create_label_types(self, max_path):
        properties = ['acceptor','aromatic', 'donor', 'hydrophobic',  'positive', 'negative']
        allProperties = []
        for source in properties:
            for target in properties:
                for d in range(1, max_path + 1):
                    allProperties.append(source + '-' +str(d) + '-' + target)
        return allProperties
    # build matrix from graph properties
    # return a data frame where rowas are graphs and columns are properties
    def run(self, is_binary):
        max_path, row_labels, graphsProperties = self.list_properties()
        col_labels = self.create_label_types(max_path)
        col_labels.sort()

        # matrix dimensions
        rows_len = len(row_labels) # number of graphs
        col_len = len(col_labels) # number of attribute pairs
        count_matrix = np.zeros((rows_len, col_len)) # init matrix

        for graph in graphsProperties:
            for j, prop in enumerate(col_labels):
                if prop in graphsProperties[graph]:
                    count_matrix[graph][j] = graphsProperties[graph][prop]

        if is_binary:
            r, c = count_matrix.shape
            for i in range(r):
                for j in range(c):
                    if count_matrix[i][j] > 0:
                        count_matrix[i][j] = 1

        return pd.DataFrame(count_matrix, columns = col_labels, index = row_labels)

class SVD:
    # In: singular values
    def get_knee(self, sgl_values):
        values = list(sgl_values)
        #get coordinates of all the points
        nPoints = len(values)
        allCoord = np.vstack((range(nPoints), values)).T
        # get the first point
        firstPoint = allCoord[0]
        # get vector between first and last point - this is the line
        lineVec = allCoord[-1] - allCoord[0]
        lineVecNorm = lineVec / np.sqrt(np.sum(lineVec**2))
        # find the distance from each point to the line:
        # vector between all points and first point
        vecFromFirst = allCoord - firstPoint
        ''' To calculate the distance to the line, we split vecFromFirst into two
        components, one that is parallel to the line and one that is perpendicular
        Then, we take the norm of the part that is perpendicular to the line and
        get the distance.
        We find the vector parallel to the line by projecting vecFromFirst onto
        the line. The perpendicular vector is vecFromFirst - vecFromFirstParallel
        We project vecFromFirst by taking the scalar product of the vector with
        the unit vector that points in the direction of the line (this gives us
        the length of the projection of vecFromFirst onto the line). If we
        multiply the scalar product by the unit vector, we have vecFromFirstParallel
        '''
        scalarProduct = np.sum(vecFromFirst * repmat(lineVecNorm, nPoints, 1), axis=1)
        vecFromFirstParallel = np.outer(scalarProduct, lineVecNorm)
        vecToLine = vecFromFirst - vecFromFirstParallel
        # distance to line is the norm of vecToLine
        distToLine = np.sqrt(np.sum(vecToLine ** 2, axis=1))
        # knee/elbow is the point with max distance value
        return np.argmax(distToLine) + 1

    # In: rank, sigle values and rows
    def low_rank_approximation(self, s, V, rank):
        return np.transpose(np.dot(np.diag(s[:rank]), V[:][:rank]))
    # Run sdv and low rank approximation
    def run(self, X):
        U, s, V = np.linalg.svd(np.transpose(X), full_matrices=True)
        # Norm s values
        sing_v = s * (1/np.sum(s))
        #
        rank = self.get_knee(sing_v)
        # low rank aproximation
        return self.low_rank_approximation(s, V , rank)

class Clustering:
    def run(self, X, labels):
        kmeans = KMeans(n_clusters = 3, random_state=0).fit(X)
        map = {}
        for i, l in enumerate(labels):
            map[l] = kmeans.labels_[i]
        return map

if __name__ == '__main__':
    X = CountingMatrix('test/out/graphs/').run(False)
    X2  = SVD().run(X)
    print(Clustering().run(X2, X.index))
    #print(silhouette_score(X, kmeans.labels_))
