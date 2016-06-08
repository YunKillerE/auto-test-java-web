INSERT INTO tb_exam_company VALUES (COMPANY_ID, 'COMPANY_NAME', 'dwnpy', 1, '', 'description');
insert into tb_hospital_exam_company_relation (hospital_id, company_id, discount, show_report, show_invoice, employee_import, support_anytime_import, create_time, settlement_mode) values (HOSPITAL_ID, COMPANY_ID, 1, 0, 0, 0, 0, now(), 0);
