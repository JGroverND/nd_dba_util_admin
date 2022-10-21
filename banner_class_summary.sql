select count(0), gtvclas_sysi_code, gtvclas_owner
from  bansecr.gtvclas
group by gtvclas_sysi_code, gtvclas_owner
order by gtvclas_sysi_code, gtvclas_owner;

--
-- where are my unassigned or empty classes
--
select c.gtvclas_class_code,
        count(0) as "Assigned Users"
from  bansecr.gtvclas c
right outer join bansecr.gurucls u on u.gurucls_class_code = c.gtvclas_class_code
group by  c.gtvclas_class_code
order by 2, 1

--
-- Interesting stats
--
select GURUCLS_CLASS_CODE, 
        count(0) as "assignees"
from bansecr.gurucls
group by GURUCLS_CLASS_CODE
order by 2