--create table seeker_profile_copy (
--	user_account_id uuid NOT NULL,
--	first_name varchar(50),
--	last_name varchar(50),
--	current_salary numeric,
--	is_annually_monthly bpchar(1),
--	currency varchar(50),
--	CONSTRAINT seeker_profile_copy_pk PRIMARY KEY (user_account_id),
--	CONSTRAINT seeker_profile_copy_fk FOREIGN KEY (user_account_id) REFERENCES "User Management".user_account(id)
--);


-------Question 4
--alter table seeker_profile_copy add "desc" varchar(100) null;
--alter table seeker_profile_copy drop column "desc";


-------Question 5
--drop table seeker_profile_copy;


--select sss.user_account_id, ss.skill_set_nam 
--from "Seeker Profile Builder".seeker_skill_set sss left outer join "Seeker Profile Builder".skill_set ss on sss.skill_set_id = ss.id 
--where sss.user_account_id = '049f9488-6b64-4145-aa55-a1a9a88884ff'


--select ed.*, ed2.*
--from "Seeker Profile Builder".education_detail ed left outer join "Seeker Profile Builder".seeker_profile sp on ed.user_account_id = sp.user_account_id,
--		"Seeker Profile Builder".experience_detail ed2 left outer join "Seeker Profile Builder".seeker_profile sp1 on ed2.user_account_id = sp1.user_account_id
--where ed.user_account_id = '049f9488-6b64-4145-aa55-a1a9a88884ff' and  ed.user_account_id = ed2.user_account_id 


--select ed.user_account_id , ed.certificate_degree_name, ed.major , ed2.job_title, ed2.company_name 
--from "Seeker Profile Builder".education_detail ed, "Seeker Profile Builder".experience_detail ed2
--where ed.user_account_id = '049f9488-6b64-4145-aa55-a1a9a88884ff' and  ed.user_account_id = ed2.user_account_id



-------Question 8
--a
--select sss.user_account_id, ss.skill_set_nam 
--from "Seeker Profile Builder".seeker_skill_set sss left outer join "Seeker Profile Builder".skill_set ss on sss.skill_set_id = ss.id 
--where sss.user_account_id = '049f9488-6b64-4145-aa55-a1a9a88884ff'


--b
--select jp.job_location_id , count(jp.job_location_id) as job_loc_count
--from "Job Post Management".job_post jp
--group by jp.job_location_id  
--order by job_loc_count desc limit 1;

--c
--select jp.id 
--from "Job Post Management".job_post jp
--where jp.id not in (
--			select jpa.job_post_id 
--			from "Job Post Management".job_post_activity jpa 
--			);

--d
--select JA.user_account_id, JA.job_post_id, JA.apply_date
--from "Job Post Management".job_post_activity JA
--where JA.job_post_id = '50cf7b8f-7c56-45a8-b9be-8c0bb82cc859'
--order by JA.apply_date desc;


--e
--select jpa.job_post_id, count(jpa.user_account_id)
--from "Job Post Management".job_post_activity jpa
--group by jpa.job_post_id


--f
--select JP.id
--from "Job Post Management".Job_post JP left outer join "Job Post Management".job_post_activity JA on JP.id = JA.job_post_id
--group by JP.id
--having count(JA.user_account_id) = 0


--g
--select ed.major, count(jpa.job_post_id) as application_count
--from "Job Post Management".job_post_activity jpa inner join "Seeker Profile Builder".education_detail ed on jpa.user_account_id = ed.user_account_id 
--group by ed.major 
--order by application_count desc limit 1; 