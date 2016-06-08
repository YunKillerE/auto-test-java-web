INSERT INTO accomplish_order(order_num, status, is_absent, name, exam_date, idcard, mobile, age, gender, marriage_status, exam_company, department, workno, offline_pay_amount) VALUES('MYSQL_ORDER_NUM', null, '0', 'order1', getdate(), (NULL), (NULL), '1', '1', (NULL), 'SUCCESSFUL', (NULL), (NULL), (NULL));
INSERT INTO accomplish_order_item (order_num ,item_code,item_price,refuse_flag)
select order_num,item_code,item_init_price,2 from tbl_order_item left join tbl_order on tbl_order.id = tbl_order_item.order_id where order_num='MYSQL_ORDER_NUM';
