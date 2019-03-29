11.1. Introduction  
11.2. Index Types  
PostgreSQL provides several index types: B-tree, Hash, GiST, SP-GiST, GIN and BRIN.   
B-trees：可以处理等值或范围查询场景。通常在出现“=/>/</>=/<=”等关系运算符时，planer通常会选择使用B-trees索引。  
Hash：只能处理简单是等值比较。在查询中当对索引列使用“=”关系运算符时可能会使用Hash索引。Hash索引的创建方法：CREATE INDEX name ON table USING HASH (column);  
GiST：GiST索引不是一种索引，而是一种可以实现许多不同索引策略的基础结构。  
SP-GiST：SP-GiST索引（如GiST索引）提供支持各种搜索的基础结构。 SP-GiST允许实现各种不同的非平衡的基于磁盘的数据结构，例如四叉树，k-d树和基数树（尝试）。  
GIN：GIN索引是“反向索引”，适用于包含多个组件值的数据值，例如数组。  
BRIN indexes (a shorthand for Block Range INdexes) ：BRIN索引存储关于存储在表的连续物理块范围中的值的摘要。  


11.3. Multicolumn Indexes  
目前只有B-trees、GiST、 GIN and BRIN四种类型支持多列索引，最多支持32列。  
在B-trees索引中，引导列效率最高。  

11.4. Indexes and ORDER BY  
只支持B-trees索引  
默认情况下，B-trees索引以升序存储其条目，最后为空。这意味着列上索引的正向扫描x产生满足ORDER BY x（或更详细ORDER BY x ASC NULLS LAST）的输出。索引也可以向后扫描，产生令人满意的输出ORDER BY x DESC（或者更详细ORDER BY x DESC NULLS FIRST，因为NULLS FIRST它是默认值ORDER BY DESC）  
创建索引时可以通过ASC，DESC，NULLS FIRST，和/或NULLS LAST选项调整B树索引的排序; 例如：
CREATE INDEX test2_info_nulls_low ON test2（info NULLS FIRST）;
CREATE INDEX test3_desc_index ON test3（id DESC NULLS LAST）;

11.5. Combining Multiple Indexes  
11.6. Unique Indexes  
11.7. Indexes on Expressions  
11.8. Partial Indexes  
11.9. Operator Classes and Operator Families  
11.10. Indexes and Collations  
11.11. Index-Only Scans  
11.12. Examining Index Usage  