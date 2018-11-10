###############################################################################################
#���ݴ���
###############################################################################################
    
    ###����ԭʼ���ݣ�ѡ��ǰ����###
#all<- read.csv("/Users/fanouyang/Desktop/sna_2018fall/all_data.csv")
#all<-all %>% select(vert1_id,vert2_id)  

    ###����reshape2���е�dcast��������������ʽת�ɽ�������wide������###
#library(reshape2)
#all_matrix<-all %>% dcast(vert1_id~vert2_id)
#write.csv(all_matrix,file = "/Users/fanouyang/Desktop/sna_2018fall/all_matrix.csv") 
    ###д�������������ݣ������¶��룬�����н��������ļ���ֱ�Ӷ���###
all_matrix<- read.csv("D:/zju/�γ�/ŷ��/slides/all_matrix.csv",row.names=1)
    ###����melt�������Ѿ���ת����������ʽ��long������###
#all_edge <- melt(all_matrix)
#write.csv(all_edge,file = "/Users/fanouyang/Desktop/sna_2018fall/all_edge.csv") 
    ###д���ٶ��룬�����ļ�����ֱ�Ӷ��룬ͬ��###
all_edge<- read.csv("D:/zju/�γ�/ŷ��/slides/all_edge.csv")

###############################################################################################
#network level
###############################################################################################

library(sna)
    ###ʹ��SNA����gplot������ӻ�������network�㼶���д���###
    ###�������������ݣ�����ͼ����ʾvertex�����ǩ����ǩ�ַ���Сcharacter expansion�������С��������ɫ###
    ###������������ʾ�޸�
gplot(all_matrix,gmode="digraph", displaylabels=TRUE,label.cex=0.7,label.pos=5,
      vertex.cex=2.5,vertex.col="cornflowerblue",edge.len=FALSE)
    ###�Ѿ���ת�������磬�����������в���###
overallnet=network(all_matrix)

###############################################################################################
#node level
###############################################################################################
   
    ###����in/outdegree���ֱ����ҹ��׺����յ��Ľ�����Ϣ###
id<-degree(overallnet,gmode="digraph",cmode="indegree")
od<-degree(overallnet,gmode="digraph",cmode="outdegree")

    ###����betweenness���Բ�ͬС�������������rescaleĬ��Ϊ�٣���Ϊ��������ܺ�Ϊ1###
bet1=betweenness(overallnet,rescale=T)
bet2=betweenness(overallnet)

    ###����closeness���������˵Ľ��ܹ�ϵ��ɢ���͵õ���Ϣ�������ߣ�rescaleͬ��###
clo1=closeness(overallnet,rescale=T)
clo2=closeness(overallnet)

    ###����eigenvector�����Ķ����ı��ع�ϵ��Խ����������������Ŀ�����Խ��rescaleͬ��###
eig1=evcent(overallnet,rescale=T)
eig2=evcent(overallnet)

    ###ʹ��SNA����gplot������ӻ�������network�㼶��node�Ƚ��д���###
    ###���������ݣ������С������ͼ
    ###      �����ǩ���ӿ��ߣ���ǩ��С��λ�ò�ƫ�ƣ���ɫ
    ###      ������ɫ����in/degree���ã�ģʽRGB��������ɫ
    ###      ��ǩ���������綥���������߿��Ȼ��ھ�������
    ###      ģʽ����fruchtermanreingold��gplot.layout��������
gplot(overallnet, vertex.cex=(id+od)^0.5/2, gmode="graph",
      boxed.labels=FALSE,label.cex=0.7, label.pos=5, label.col="grey17",
      vertex.col=rgb((id+od)/max(id+od),0,(id+od)/max(id+od)),edge.col="grey17",
      label=network.vertex.names(overallnet),edge.lwd=all_matrix/2,mode = "fruchtermanreingold")

    ###ʹ��SNA����plot.sociomatrix��ɫǿ�Ȼ��ƺ�����network���д�����ֻҪ�н����ͻ�����ʾ###
    ###���������ݣ�����ǶԽ��ߣ����⣬��ѡ��ǩ��չ���ӣ�Y/X�ı���
plot.sociomatrix(overallnet, diaglab = FALSE, 
                 main = "The overall interaction", cex.lab = 0.4, asp = 0.5)


    ###�Զ��庯����������ڵ��in/outdegree���������������ά�б�������
    ###��������ڵ����Ͳ���ֵ��������
    ###cbindȡֵ�������б��ȣ�%v%�Ӿ����б�ȡ�ض�ֵ/��
node.centrality<-function(list.net){
  lapply(list.net,
         function(z){
           x<-z
           ###���������������������������ά�ȵ�����
           central.nodes<-cbind(degree(x,cmode="indegree"), degree(x,cmode="outdegree"),evcent(x,rescale=T),betweenness(x,rescale=T),
                                closeness(x,cmode="directed",rescale=T))
           colnames(central.nodes)<-c("idegree","odegree","eigen","betweenness","closeness")
           rownames(central.nodes)<-z%v%"vertex.names"
           ###�Զ�ά�б���ÿһ�н�������
           #o1<-order(central.nodes[,1],decreasing =TRUE)
           #o2<-order(central.nodes[,2],decreasing =TRUE)
           #o3<-order(central.nodes[,3],decreasing =TRUE)
           #o4<-order(central.nodes[,4],decreasing =TRUE)
           #o5<-order(central.nodes[,5],decreasing =TRUE)
           #list(ranking=central.nodes,order=cbind(o1,o2,o3,o4,o5))
         })
}
    ###ʹ���Զ��庯����֤
nc<-node.centrality(list(overallnet))
#nc

###############################################################################################
#graph level
###############################################################################################
    
    ###SNA��centralization�������㼯�л��̶ȣ��������һ������ֵ
centralization(overallnet,degree)
centralization(overallnet,degree,cmode="outdegree")
centralization(overallnet,degree,cmode="indegree")
centralization(overallnet, betweenness)
centralization(overallnet, closeness)
centralization(overallnet, evcent)
    ###���������С���ܶȡ������ȣ�ƽ�������ȣ�����ͳ����ƽ��
network.size(overallnet)            #size
gden(overallnet,mode="graph")       #density
degree(overallnet)                  #all degreee
mean(degree(overallnet))            #average degree
sum(id)/20                          #average in degree
sum(od)/20                          #average out degree

    ###������������Ϣ���ݵĳ̶ȣ��ȼ�����������������ϵ
    ###dyad.census������������ࣺ�໥��A��B��B��A�������Գƣ�A��B��B��A�����գ��޹أ�
    ###�˴���66��62��62
dyad.census(overallnet)
    ###network.dyadcount���������ʾ�����ж�Ԫ�������������ָ������X��na.omit������Ա�Ե����
    ###�˴����overallnet��������=66+62+62=190��˫��380��δ����
network.dyadcount(overallnet, na.omit = F)
    ###network.edgecount����������������������ߣ��˴�194�����ߣ�δ����
network.edgecount(overallnet, na.omit = F)
    
    ###������������Ķ�Ԫ�����ԣ���������Ϊ�ھӹ����̶ȣ������������ھ�Ϊ1�����ھ�Ϊ0
    ###�˴����������������������(0,1]��ֻ�п�ͼ��ȫ����Ϊ1
    ###���־��������ʽ��Ĭ��dyadic
    #---edgewise= num((a,b)==(b,a))/all
    #---dyadic= num(�߽�)/�ǿ�
    #---dyadic.nonnull= �໥/�ǿգ��˴�=66/66+62=0.515625
grecip(overallnet, measure = "edgewise")
grecip(overallnet, measure = "dyadic")
grecip(overallnet, measure = "dyadic.nonnull")

    ###transitivity
    ###���������������Ԫ��Ϣ�����ԣ���Ϊǿ���ݺ������ݣ�Ĭ������������ȱʡ��Ԫ�飨a/b/c=null��
    #---��a-> b-> c => a-> c�������Ƴ�
    #---ǿa-> b-> c <=> a-> c��˫��ȼ�
gtrans(overallnet)

    ###hierarchy
    ###������������ĵȼ�����,���岻�ԳƳ̶�Խ�󣬵ȼ���νṹ��Խ��
    #---reciprocity��ʽ=1-grecip������Ĭ��dyadic��
    #---krackhardt��ʽ����ǶԳƷǿն���֮��������·����ֵ=1��else=0���ۼƷ����жϵȼ�
hierarchy(overallnet, measure = "reciprocity")
hierarchy(overallnet, measure = "krackhardt")


    ###�����ӵķ�ʽ�������������ɷ�����ͼ����Ŀ��������ֻ��һ��ͼ����Ȼ��1
components(overallnet,connected="weak")
    ###����Krackhardt�Ƽ���connectednessͼ֮������ӳ̶ȣ�gֵĬ��Ϊȫ�����ݣ�һ��ͼ=1
connectedness(overallnet, g=NULL)

    ###geodist�������нڵ�֮���·��������
    #---����ڵ��û��·����inf.replace��ֵ����
    #---count.pathsΪ���������·����������
    #---predecessorsΪ����������ǰ���ڵ�
    #---ignore.evalΪ������Ա�Ե·����Ϣ��һ��ΪTRUE
geodist(overallnet, inf.replace=Inf, count.paths=TRUE, predecessors=FALSE,ignore.eval=TRUE)
geo=geodist(overallnet)
    ###�˴��᷵��counts��gdist�����������geo��gdist���������·����������ά��
max(geo$gdist)  #diameter

    ###�Զ��庯���������������������ڵ��·����ƽ������=��·����/�ܶ�Ԫ���ϵ��
    ###ע������ͼ��Ԫ������Ҫ2��
    #---choose(network.size(net),2)=190������������ѡ��2���ڵ�������ͼdirected��ϵ����
averagePathLength<-function(net){
  if(!is.network(net)){stop("Not a Network")}
  gd<-geodist(net)
  if(net%n%"directed"){
    return((1/choose(network.size(net),2))*sum(gd$gdist))
  }
  (1/(2*choose(network.size(net),2)))*sum(gd$gdist)
}
    ###����������ƽ��·������
averagePathLength(overallnet)

    ###�Զ��庯����������ά�ȵ����·����
diameter<-function(net){
  gd<-geodist(net)
  max(gd$gdist)
}
    ###�������������·��
diameter(overallnet)


###############################################################################################
#other package
###############################################################################################

########### you can use tnet package to calculate those metrics ##########

########## igraph format analysis ##########
##### this is a good example http://kateto.net/networks-r-igraph #######
library(igraph)

# final edge list 
all_edge=read.csv("/Users/fanouyang/Desktop/sna_2018fall/all_edge.csv") 

# create igraph from the edge list
all_igraph <- graph_from_data_frame(d=all_edge, directed=T)
# cheeck node and edge
E(all_igraph)     
V(all_igraph)
# plot not pretty,  need further revise it later
plot(all_igraph, edge.arrow.size=.1)
## node-level analysis
igraph::degree(all_igraph)
igraph::degree(all_igraph,mode="out")
igraph::betweenness(all_igraph)
igraph::closeness(all_igraph, mode="in")
igraph::closeness(all_igraph, mode="out")
igraph::closeness(all_igraph, mode="all")
igraph::eigen_centrality(all_igraph)
## network level analysis
igraph::diameter(all_igraph, directed = TRUE)
dyad_census(all_igraph)
distances(all_igraph)
shortest_paths(all_igraph, 5)
centr_degree(all_igraph)$centralization
centr_clo(all_igraph, mode="all")$centralization
centr_eigen(all_igraph, directed=FALSE)$centralization

#### use visNetwork package########
# plot you should customize it later
library(visNetwork)
visIgraph(all_igraph, idToLabel = TRUE, layout = "layout_nicely",
          physics = FALSE, smooth = T)


