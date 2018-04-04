---
category: work
published: true
layout: post
title: 读书笔记_A Location-Content-Aware Recommender System
description: read more.
---

 
##  背景描述 
文章是从两周前综述下继续按图索骥过来的。  
文章的亮点在于Content-Aware  

`Hongzhi Yin, Yizhou Sun, Bin Cui, Zhiting Hu, and Ling Chen. Lcars: a location-content-aware recommender system. In Proceedings of the 19th ACM SIGKDD international conference on Knowledge discovery and data mining, pages 221–229. ACM, 2013`
~~ a~~
>* 1
http://www.cse.ust.hk/~raywong/comp5331/ProjectReferences/KDD13-LocationRecommendation.pdf

 
都是大部分都是清华的学生
13年的文章
文章的亮点在：于不仅在国内地区而且在一个没有活动历史的城市里LCARS可以方便人们的出行。
Authors:
Hongzhi Yin	Peking University, Beijing, China 
Yizhou Sun	Northeastern University, Boston, USA
Bin Cui	Peking University, Beijing, China
Zhiting Hu	Peking University, Beijing, China
Ling Chen	University of Technology, Sydney, Sydney, Australia
Survey对其描述
the opinions from the local experts. Yin et al. 2013 [114] further extend the problem by proposing an LCA-LDA model, a location-content-aware probabilistic generative model to quantify both the local preference and the item content information in the recommendation process.


建立一个LCA-LDA模型去通过位置偏好和内容信息去评价划分。

## 摘要ABSTRACT

关键点：
Probabilistic generativemodel; 概率生成
TA algorithm; 阈值算法
 Cold start冷启动
LCARS, a location-content-aware recommender system 基于内容的定位推荐

The offline modeling part, called LCALDA, is designed to learn the interest of each individual user and the local preference of each individual city by capturing item cooccurrence patterns and exploiting item contents.

LCA-LDA
基于内容的定位和离线的捕捉用户模式和兴趣爱好的一个模型部分

介绍INTRODUCTION
Newly emerging event-based social network services新兴的基于事件的社会网络服务
location-based social networking services (LBSNs),

文章的目的：解决定位问题，
比如推荐北京的场馆
北京的重要活动如展览演唱会等
 
基本逻辑思维线路：
请求需求-》阈值推荐—》检索
用户个人信息-》LCALDA模型-》用户网络和用户偏好-》检索
LCALDA模型-》检索离线的用户的历史数据
定位，内容敏感的推荐系统
 LOCATION-CONTENT-AWARE RECOMMENDER SYSTEM
## 2.1基本定义

 
2.2离线推荐模型
Model Description. The proposed offline modeling part, LCALDA, is a location-content-aware probabilistic mixture generative model that aims to mimic the process of human decision making on spatial items
LCSLDA模型的目的是一个定位，内容敏感的可能性混合的生成模型，旨在模仿人在对空间抉择时候的过程。
 
 
通过算法描述得出的结论
 
 
在线推荐系统
对于在线推荐阶段，我们必须计算查询用户的所有空间项目的偏好分数，在查询的城市，并随后选择最佳的推荐给用户。当空间项目数变大计算每个查询的最高k个空间项目需要数以百万计的向量运算。通过检查最小数量的空间项目阈值算法能够正确找到Top-k结果
## 实验

实验准备
数据集
1、	使用豆瓣事件
2、	LBSNs dataset, Foursquare 
比较方法:
LDA: Following previous works [11, 5], a standard LDAbased method is implemented as one of our baselines. Compared with our proposed LCA-LDA, this method neither considers the content information of spatial items, nor their location information. For online recommendation, the ranking score is computed using our ranking framework in Equation 16 where F(lu, v, z) = φˆzv, W(u, lu, z) = ˆθuz.
LDAbased方法是基准线，对比LCALDA方法既不被内容敏感，也不被他们的定位信息所敏感。在线推荐系统用狂街内的 来计算排名分数。

Location-Aware LDA (LA-LDA): As a component of the proposed LCA-LDA model, LA-LDA means our method without considering the content information of spatial items. For online recommendation, the ranking score is computed using our proposed ranking framework in Equation 16 where F(lu, v, z) = φˆzv and W(u, lu, z) = λˆu ˆθuz+(1−λˆu)ˆθ luz.
LALDA不需要考虑空间位置空间的内容信息，在线推荐系统，排名分数也是通过上述16在F(lu, v, z) = φˆzv and W(u, lu, z) = λˆu ˆθuz+(1−λˆu)ˆθ luz.计算的
Content-Aware LDA (CA-LDA): As another component of the LCA-LDA model, CA-LDA means our method without exploiting the location information of spatial items, i.e., local preference. It can capture the prior knowledge that spatial items with the same or similar contents are more likely to belong to the same topic. This model is similar to the ACT model [26] in the methodology. For online recommendation, the ranking score is computed using our ranking framework in Equation 16
CALDA不需要探索定位信息，当地偏好。用来捕捉基于相同话题的相同或者相似的内容去理解空闲事物。对于在线推荐模型是基于 和 的 计算的。
 
## 实验结果

推荐系统的效果
 
推荐系统的效率
 
本地偏好影响研究 
In this section, we study the effects of personal interest and local preference on users’ decision making. The self interest influence probability λu and the local preference influence probability 1−λu are learnt automatically in our proposed LCA-LDA model. Since different people have different mixing weights, we plot the distributions of both self interest and local preference influence probabilities among all users. The results on the DoubanEvent data set are shown in Figure 7, where Figure 7(a) plots the cumulative distribution of self interest influence probabilities, and Figure 7(b) shows the local preference influence probabilities. It can be observed that, in general, people’s self interest influence is higher than the influence of the local preference. For example, Figure 7(a) shows that the self interest influence probability of more than 70% of users is higher than 0.5. The implication of this finding is that people mainly attend social events based on their self interests, and they sometimes attend popular local events regardless of their interests, especially when travelling in new cities. This finding also explains the superiority of LCA-LDA and LA-LDA in the recommendation performance (Section 3.2.1).
个人兴趣和本地偏向对于人做决定的时候。个人兴趣影响因素和当地偏向的影响因素在LCALDA系统里面会被自动的考虑。因为不同的人有不同的混合圈子，我们对于当地的偏好可能性做了区分，结果如下图。7a表明，个人兴趣的影响可能性大于70%高于0.5.说明人主要参与他们感兴趣的社会活动，他们又是参与他们不敢兴趣的流行的活动，特别是当在新城市旅行的时候。这个发现解释了推荐系统的表现。
 
## 相关工作

通常的推荐系统
协同过滤和基于内容的过滤技术是一种广泛采用的推荐系统的方法。他们都发现了用户的个人利益，并利用这些发现的利益，找到相关的项目。协同过滤技术从其他口味相似的用户自动为一个给定的用户通过引用项目评级信息提出相关的项目。推荐系统使用纯的协同过滤的方法往往失败. 我们在这项工作中的建议不仅能 融合协同过滤和内容敏感方法，而且采用了局部偏好的方法推荐流程。
基于定位的推荐系统
通过使用一个模型的基础上的开采轨迹模式。从用户的活动历史个性化的建议。具体而言，将人们的活动历史记录到用户的场地矩阵中，每一行对应于用户的访问历史每一列代表一个如餐厅的场地。然后对于一个未访问的地点，基于用户推断用户的喜好。
结论
本文提出了一种位置内容感知推荐系统，LCARS，它提供了一个用户空间项目的建议基于个人利益的质疑和从用户的活动历史中挖掘的局部偏好。不仅在国内地区而且在一个没有活动历史的城市里LCARS可以方便人们的出行。通过利用两者的内容和位置信息空间项目，我们的系统克服了数据稀疏性问题原始用户项矩阵。我们评估我们的系统使用广泛基于真实数据集的实验研究。根据实验结果，我们的方法显着优于现有有效性推荐方法。结果也证明我们的系统中的每个组件，如采取本地偏好和项目内容信息，并提出可扩展的查询处理技术提高了效率我们的方法显着。

## 致谢

略

## 引用

略
