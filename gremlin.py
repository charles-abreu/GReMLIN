#-----------------------------------------------------------------------
# Developed by Charles Abreu Santana
# 07/01/2018
#-----------------------------------------------------------------------
import sys, os, getopt, timeit
import numpy as np
from glob import glob
from clustering import CountingMatrix, SVD, Clustering
from modeling import Modeling
from graphmining import GraphJson, SplitGroup, Gspan, MapPattern
#-------------------------------
# Main
#-------------------------------
def run(argv):
    try:
        opts, args = getopt.getopt(argv,"hd:o:", ['help', 'dataset=','output='])
    except getopt.GetoptError:
        print ('gremlinp.py -d <dataset_dir> -o <out_dir>')
        sys.exit(2)

    data_dir = ''
    out_dir = ''

    for opt, arg in opts:
        if opt == '-h':
            print ('gremlin.py -d <dataset_dir> -o <out_dir>')
            sys.exit()
        elif opt in ("-d", "--dataset"):
            data_dir = arg
        elif opt in ("-o", "--output"):
            out_dir = arg

    fileList = glob(data_dir + os.sep +'*.pdb')

    if(len(fileList) == 0):
        print("Warning! - PDB files not found!")
    else:
        graph_dir = out_dir + os.sep + 'graphs/'
        group_dir = out_dir + os.sep + 'groups/'
        sup_dir = out_dir + os.sep + 'supports/'
        pattern_dir = out_dir + os.sep + 'patterns/'
        graphml_dir = out_dir + os.sep + 'graphml/'
        # MODELING
        #-----------------------------
        start = timeit.default_timer()
        #------------------------------
        # Computing graphs
        Modeling(data_dir, graph_dir, out_dir).run(7, [])
        # CLUSTERING
        # Computing matrix using graph caracteristics
        X = CountingMatrix(graph_dir).run(False)
        # Romove noise data using SVD
        X2 = SVD().run(X)
        # Clustring
        groups = Clustering().run(X2, X.index)
        # GRAPH MINING
        supports = np.arange(0.1, 1.0, 0.1)
        # file with all graphs in gsapn format
        gsp = out_dir + os.sep + "graph_dataset.gspan"
        # Updating graph files information
        GraphJson().update_json(graph_dir, gsp, groups)
        # Partiotioning graphs into groups
        gl, mg = SplitGroup(out_dir).run(groups, graph_dir)
        # Running Gspan and colecting maximal patterns
        Gspan(group_dir).run(supports, gl, mg)
        Gspan(group_dir).save_patterns(pattern_dir, mg)
        # Mapping patterns into original graphs
        MapPattern(sup_dir).run(supports, gl,graph_dir, pattern_dir)
        # Creating graphml files
        GraphJson().json_to_graphml(graph_dir, graphml_dir)
        #------------------------------
        stop = timeit.default_timer()
        print('Runtime: ')
        print (stop - start)
        #------------------------------
if __name__ == '__main__':
    run(sys.argv[1:])
