CREATE VIEW tbl_order_view as
select
        o.id,
		o.order_num,
		o.exam_date,
		o.name,
		o.idcard,
		o.financename,
		o.department,
		o.fee_type,
        o.owner,
		o.status,
		o.import_time,
		o.[operator],
		o.his_bm,
		c.his_exam_company_code,
        o.cancel_order_flags,
		o.[position],
		o.cancel_order_status,
		o.meal_name,
		o.meal_code,
        o.health_num,
		o.is_retire,

		o.mobile,
		o.health_level,
		o.marriage_status,
		o.his_tjkh,
        o.order_money,
		o.online_pay_money,
		o.offline_pay_money,
		o.[sequence],
		o.is_vip,
        o.workno,
		o.has_paperreport,
		remark
from tbl_order o left join exam_company c
on
        c.mytijian_exam_company_code = o.exam_company_code
        and c.exam_company_name = o.exam_company_name
