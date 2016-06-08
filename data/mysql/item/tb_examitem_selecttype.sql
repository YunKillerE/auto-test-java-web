select type as cc from tb_examitem_change_log where item_id=(select id from tb_examitem where his_item_id='MEDAUTO_ITEM_CODE' and hospital_id=HOSPITAL_ID) order by id desc limit 1;

