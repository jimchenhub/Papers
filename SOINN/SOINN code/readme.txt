What Is SOINN?
==============
SOINN:       Self-Organizing Incremental Neural Network is an
             Neural Network model for incremental or on-line
             learning. It is proposed by Dr. Furao Shen and Osamu
 	     Hasegawa in 2006: Shen Furao & Osamu Hasegawa, "An  		 		 
             Incremental Network for On-line Unsupervised Classification   		 
             and Topology Learning," Neural Networks, vol. 19, pp.90-		 	 
             106, 2006. SOINN has been applied to Active Learning, 			 
             Transfer Learning, Associative Memory and some other fields 		 
             in rencent years. Some more advanced readings can be found 		 
             in http://cs.nju.edu.cn/rinc/. If you have any problems 			 
             please contact the author: frshen@nju.edu.cn.


Function Declaration:
=====================
[node, connection] = fastSOINN(data, agemax, lambda, c);     
            
Input:
      data = N x D matrix. The matrix of your training set.
             N is the number of your data points.
             D is the demension of your data.
      For example, you have 3 2-demensional pionts in your training set:
      [1,2],[3,4],[5,6]. Then data is: [1,2
                                        3,4
                                        5,6]
 
      agemax = The outdate degree of connections between prototypes.
               If a connection between some two prototypes i and j 
               (i, j < M) with an age(i,j) > agemax. The connection
               will be deleted.
 
      lambda = The cycle of noise processing.
               Every lambda points of your data are learned by SOINN,
               SOINN would denoising the learned prototypes.
 
      c = The control parameter of denoising. In the range of [0,1].
          The prototype which has only one neighbor and the density of
          this prototype is less than c*mean_density, SOINN will delete
          this prototype as a noise point.
 
 
Output: 
        node = M x N matrix. Edge matrix for neighborhood graph
               M is the number of the learned prototypes.
               D is the demension of your data.
 
        connection = M x M matrix.
               If there is a connection between some two prototypes 
               i and j (i, j < M), the connection(i,j) = 1. Else 
               connection(i,j) = 0.
 

