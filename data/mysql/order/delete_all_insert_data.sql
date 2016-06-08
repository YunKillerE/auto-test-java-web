delete from tb_order_relation where order_id=COMPANY_ID;
delete from tb_order_log where order_id=COMPANY_ID;
delete from tb_order where id=COMPANY_ID;
delete from tb_hospital_exam_company_relation where company_id=COMPANY_ID;
delete from tb_exam_company where id=COMPANY_ID;
