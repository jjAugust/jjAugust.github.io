---
category: work
published: true
layout: post
title: 读书笔记_12月最后一周Report
description: read more.
---
#  WeekReport



1、研究matlab和数据库postGreSql的链接。中间遇到了一些问题，最终解决（关于的是中间件jdbc方面的）。
这项完成的优点是为以后的实验打下基础，以后的数据源入库后能方便的通过matlab和数据库postGreSql实现展示。
简单实现了在地图上进行打点（40000个），因为是世界地图，放大之后的经纬度等需要进行地图方面的调试。最后一个其实是北京方面的，我在CSDn上面下了一个北京的shx矢量图，但是没成功

![s5.png](/Users/xiongjunjie/Desktop/132.png)  
![s5.png](/Users/xiongjunjie/Desktop/133.png)
这幅是北京大致的打点，还可以放大，但是效果一般，原因是因为没有对应的shx北京的矢量图。
![s5.png](/Users/xiongjunjie/Desktop/131.png)  


2、老师深入交谈，粗看了文档《空间数据挖掘与信息共享教育部重点实验室开放课题申请书(2016版)-南邮-邹志强》
3、沿着周二晚上探讨的思路整理和梳理，阅读文献4篇，备注reference（见word文档）
4、批改助教的作业和整理相关计分文档。

## 背景：  
Christian Sengstock, Michael Gertz, Florian Flatow, Hamed Abdelhaq Institute of Computer Science
Heidelberg University, Germany
[作者背景](http://dbs.ifi.uni-heidelberg.de/index.php?id=73)
![s5.png](/Users/xiongjunjie/Desktop/111.png)   
  

  
  
- 作者  
这位第一作者研究LBSN方向，这里面有他的一些近作。持续跟进中.  
* [http://dbs.ifi.uni-heidelberg.de/index.php?id=73](http://dbs.ifi.uni-heidelberg.de/index.php?id=73)  
![s6.png](/Users/xiongjunjie/Desktop/112.png)   
 
  
  


## 文章结构：  

### ABSTRACT  
略写  
> Our approach models spatio-temporal and semantic knowledge about real-world phenomena embedded in records on the basis of conditional probability distributions in a Bayesian network
 generic and comprehensive model
通过贝叶斯网络距离，说明模型，后续详细。

### INTRODUCTION  
略写

> In this work, we present a probabilistic model to extract spatio-temporal distributions of phenomena, called spatio- temporal phenomenon signals, from social media. We de- scribe the spatio-temporal and semantic information about real-world phenomena embedded in the records on the basis of conditional probability distributions in a Bayesian net- work.

从社交媒体中提出时空现象信号，基于这些记录在贝叶斯网络描述时空和语义信息用可能的分布式中。 

> The remainder of the paper is structured as follows. In the following section, basic concepts and our problem statement are given. In Section 3, we survey related work. In Section 4, we give a brief review of Bayesian networks. Then we define our model and discuss inference in Section 5. In Sec- tion 6, particular model instances are proposed. In Section 7, we present several experiments discussing the influence of parameters and show results of a quantitative evaluation against ground-truth knowledge. We summarize our contri- butions and outline ongoing work in Section 8.



- 2、	第三章相关工作
- 3、	第四章介绍贝叶斯网络  
- 4、	第五章讨论模型 
- 5、	第六章特殊模型的讨论
- 6、	第七章讨论参数和给出评价图
- 7、	第八章是总结和将来的工作方向  

### DEFINITIONS AND PROBLEM STATEMENT

* Social Media
* Spatio-temporal Phenomenon Signal
* Measurements, Uncertainty, and Hetero- geneity
* Problem Statement and Contributions
略
  
### 相关工作
  
有很多相关文献可以参考，略写

### BAYESIAN NETWORKS

![s2.png](/Users/xiongjunjie/Desktop/113.png)   

### 模型

文章分了很多情况，描述了不同情况应该采用的模型
#### Probabilistic Signal Extraction
#### Random Variables
#### Network
#### Spatio-temporal Record Influence
#### Semantic Record Influence
#### Semantic Confidence
#### User Record Influence
#### Redundant Measurements
#### Probabilistic Inference
#### Signal Prior
#### Spatial Interaction


### 实验
用的twitter数据，截图部分，略写，并没有细看实现。不过这个模型涉及到了一个调参的过程，也许在以后的过程中需要回头参考。。。

![s2.png](/Users/xiongjunjie/Desktop/114.png)   
![s2.png](/Users/xiongjunjie/Desktop/115.png)   
![s2.png](/Users/xiongjunjie/Desktop/116.png)   
![s2.png](/Users/xiongjunjie/Desktop/117.png)   


### 结论  
文章主要论述不同的情况使用不同的模型

### 将来的工作  

>we consider future work in the following areas: We accounted for spatio-temporal interaction between context bins by applying a local filter on the signal. In ongoing work we study Markov Random Fields to include spatio- temporal interaction into the model. Also, since we are able to use arbitrary functions describing the semantic value of a record to a phenomenon, and to extend the model to take user connections into account, we want to investigate mean- ingful combinations in order to extract high quality signals for particular phenomena.

提出了作者正在参考的几个模型。 比如马尔科夫随机走的模型等等。


# Travel Time Estimation of a Path using Sparse Trajectories

## 作业&&背景
Yilun Wang1,2,*, Yu Zheng1,+ , Yexiang Xue1,3,*
1Microsoft Research, No.5 Danling Street, Haidian District, Beijing 100080, China 2College of Computer Science, Zhejiang University
3Department of Computer Science, Cornell University

微软的研究组

## ABSTRACT
> In this paper, we propose a citywide and real-time model for estimating the travel time of any path 

> The first is the data sparsity problem, i.e., many road segments may not be traveled by any GPS-equipped vehicles in present time slot. In most cases, we cannot find a trajectory exactly traversing a query path either. Second, for the fragment of a path with trajectories, they are multiple ways of using (or combining) the trajectories to estimate the corresponding travel time. Finding an optimal combination is a challenging problem, subject to a tradeoff between the length of a path and the number of trajectories traversing the path (i.e., support). Third, we need to instantly answer users’ queries which may occur in any part of a given city.

三点，数据稀少，方法太多，需要实时响应


## OVERVIEW

> In this paper, we propose a model for instant Path Travel Time Estimation (PTTE), based on sparse trajectories generated by a sample of vehicles (e.g., some GPS equipped taxicabs) in the recent time slots as well as in history. Our model is comprised of two major components. One is to estimate the travel time for road segments without being traversed by trajectories through a context-aware tensor decomposition (CA TD) approach. The second is to find the most optimal concatenation (OC) of trajectories to estimate a path’s travel time using a dynamic programing solution. 

通过ptte模型基于最近历史数据的稀疏轨迹。两部分组成：1、是不依赖穿越上下文感知张量的轨迹 2、是动态过程解决评估一条路径的时间。
![s2.png](/Users/xiongjunjie/Desktop/124.png)  
![s2.png](/Users/xiongjunjie/Desktop/125.png)  


## DEALING WITH MISSING VALUES

> In reality, tensor   is very large, given hundreds of thousands of road segments and tens of thousands of drivers. Decomposing such a big tensor is very time consuming, therefore reducing the feasibility of our method in providing online services. To address this issue, as illustrated in Figure 6, we partition a city into several disjoint regions, building a tensor for each region based on the data of the region. The matrices   and   are built in each smaller region accordingly. By setting a proper splitting boundary, we try to keep these small tensors a similar size. As a result,   is replaced by a few small tensors, which will be factorized in parallel and more efficiently. We validate (in later experiments) that the partition does not compromise the accuracy of the original decomposition when choosing a proper number of partitions.

首先需要拆分，减少提高在线服务的可行性。划分不相交的区域建立张量的区域数据，尽量把小的张量的大小相似，这将有效的分解并行。需要选择合适的数量的分区。
![s2.png](/Users/xiongjunjie/Desktop/126.png) 
![s2.png](/Users/xiongjunjie/Desktop/127.png) 

## OPTIMAL CONCATENATION最佳级联

![s2.png](/Users/xiongjunjie/Desktop/128.png) 
![s2.png](/Users/xiongjunjie/Desktop/130.png) 

## 实验

> Taxi Trajectories. We use a GPS trajectory dataset generated by 32,670 taxicabs in Beijing from Sept. 1 to Oct. 31, 2013. The number of GPS points reaches 673,469,757, and the total length of the trajectories is over 26,218,407km. The average sampling rate is 96 seconds per point.
Road networks: We use the road network of Beijing, which is comprised of 148,110 nodes and 196,307 edges. The road network covers a 40 50km spatial range, with a total length (of road segments) of 21,985km.
POIs: The dataset consists of 273,165 POIs of Beijing, which are classified into 195 tier two categories. We only chose the top 10 categories that occur around road segments most frequently.

![s2.png](/Users/xiongjunjie/Desktop/137.png) 
## 结论

> We study the performance of PTTE changing over different number of vehicles in Figure 17, aiming to figure out how many GPS equipped vehicles are needed to have accurate results. For example, using 30,000 GPS-equipped vehicles in Beijing is enough to achieving a MRE smaller than 0.23. In other words, if having 1.36 vehicles on every kilometer road in a city, we can achieve a relative error of estimation smaller than 0.23.

![s2.png](/Users/xiongjunjie/Desktop/135.png) 
![s2.png](/Users/xiongjunjie/Desktop/136.png) 
## 相关工作

## CONCLUSION

> In this paper, we propose a real-time and citywide model, called PTTE, to estimate the travel time of a path in current time slot in a city’s road network, using the GPS trajectories from a sample of vehicles (e.g. taxicabs). 

### 几个生词
proxy 代理
extract 取出
embedded 嵌入
generic 普通的
Annotation 注释