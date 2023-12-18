

-- 1 Order the food group based on descending order of average calories 
SELECT group_details as 'Food group', AVG(energy_in_kcal) as 'Average energy in kcal'  
from food_group fg
join food_description fd  on fd.group_id = fg.food_group_id 
group by group_details
order by AVG(energy_in_kcal) desc;

-- 2 List of all names and descriptions of food items

SELECT common_name as name , fd.description 
FROM common_name cn 
JOIN food_description fd ON cn.food_id = fd.food_id 
UNION 
SELECT  manufacturing_name  as name ,fd.description
FROM manufacturing_name mn 
JOIN food_description fd ON mn.food_id = fd.food_id
UNION
SELECT scientific_name as name ,fd.description
FROM scientific_name sn  
JOIN food_description fd ON sn.food_id = fd.food_id;


-- 3 % of Protein content to recommended content for food items

SELECT fd.description , 100*round(nc.nutrients_in_g/nl.recommended_daily_amounts,3) 
as '% of Protein content to recommended content'  
FROM nutrient_list nl 
JOIN nutrients_contained nc  ON nl.nutrient_id = nc.nutrient_id 
JOIN food_description fd ON fd.food_id = nc.food_id 
WHERE nl.nutrient_name like 'Protein%';

-- 4 Count the number of countries for each nutrient with atleast 3% prevalence


SELECT  nl.nutrient_name , count(country_name ) as 'Countries with > 3% deficiency'
FROM prominent_deficiencies_by_country pdbc 
JOIN country_deficiency_relationship cdr ON pdbc.country_id = cdr.country_id 
JOIN nutrient_list nl ON nl.nutrient_id = cdr.nutrient_id 
where cdr.Prevalence_of_deficiency > 3 
group by nl.nutrient_name ;

-- 5 Proportion of each food group in diets based on diet_food_details


SELECT fg.group_details ,dafp.diet_name , 
case 
	when dfc.diet_food_details = 'can be skipped' THEN 0.25
	when dfc.diet_food_details = 'needed sometimes' THEN 0.5
	when dfc.diet_food_details = 'essential' THEN 0.75
end as 'Proportion allowed in diet' 
FROM food_group fg 
JOIN food_description fd on fg.food_group_id = fd.group_id 
join diet_food_combination dfc on dfc.food_id = fd.food_id 
join diets_and_food_preferences dafp on dafp.diet_id = dfc.diet_id ;










