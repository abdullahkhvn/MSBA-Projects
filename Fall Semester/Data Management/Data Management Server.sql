CREATE table vendor_only_ca as
select vendor_name, vendor_address1, vendor_address2, vendor_city, vendor_phone
from vendors
where vendor_state 
= 'CA'
order by vendor_city;

select * from vendor_only_ca;

update vendor_only_ca
set vendor_name = 'Who cares!?!' ;

rollback;


