--1)	Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN ordernumber TYPE smallint USING ordernumber::smallint,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN quantityordered TYPE smallint USING quantityordered::smallint,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN orderlinenumber TYPE smallint USING orderlinenumber::smallint,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN sales TYPE numeric USING sales::numeric,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN orderdate TYPE date USING orderdate::date,
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN msrp TYPE smallint USING msrp::smallint

--2)	Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
select * from sales_dataset_rfm_prj
where QUANTITYORDERED is null or PRICEEACH is null or ORDERLINENUMBER is null or SALES is null or ORDERDATE is null 

--3)	Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
--	CONTACTFIRSTNAME
ALTER table sales_dataset_rfm_prj ADD column contactfirstname VARCHAR(50) 
UPDATE public.sales_dataset_rfm_prj
SET contactlastname = upper(substring(contactfullname,position('-'in contactfullname) + 1,1))|| lower(right(contactfullname,length(contactfullname)-position('-'in contactfullname) - 1))
--	CONTACTLASTNAME:
ALTER table sales_dataset_rfm_prj ADD column contactlastname VARCHAR(50) 
UPDATE public.sales_dataset_rfm_prj
SET contactlastname = UPPER(substring(contactfullname,1,1)) ||lower(substring(contactfullname,2,position('-'in contactfullname)-2))

--4)	Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
--QRT_ID
ALTER TABLE public.sales_dataset_rfm_prj
add column QTR_ID smallint
UPDATE public.sales_dataset_rfm_prj
SET QTR_ID=case
	when extract(month from orderdate) in ('1','2','3') then 1
	when extract(month from orderdate) in ('4','5','6') then 2
	when extract(month from orderdate) in ('7','8','9') then 3
	else 4
end
--MONTH_ID
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN MONTH_ID smallint
UPDATE public.sales_dataset_rfm_prj
SET MONTH_ID=extract(month from orderdate)
--YEAR_ID
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN YEAR_ID smallint
UPDATE public.sales_dataset_rfm_prj
SET YEAR_ID=extract(YEAR from orderdate)

--5) Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
--Z-Score 
with a as(select quantityordered, (select avg(quantityordered) from public.sales_dataset_rfm_prj) as avg,
(select stddev(quantityordered) from public.sales_dataset_rfm_prj) as stddev
from public.sales_dataset_rfm_prj)
select quantityordered, (quantityordered-avg)/stddev as z_score from a
where abs((quantityordered-avg)/stddev)>3
--Box plot:
with box_plot as (select Q1-1.5*IQR as min,Q1,Q3, Q3+1.5*IQR as max from 
(select PERCENTILE_CONT (0.25) within group (order by quantityordered) as Q1,
PERCENTILE_CONT (0.75) within group (order by quantityordered) as Q3,
PERCENTILE_CONT (0.75) within group (order by quantityordered)-PERCENTILE_CONT (0.25) within group (order by quantityordered) as IQR
from public.sales_dataset_rfm_prj) as a)
select * from public.sales_dataset_rfm_prj
where quantityordered < (select min from box_plot) or
quantityordered > (select max from box_plot)



