create database hackathon;
use hackathon;

create table patients (
	patient_id varchar(10) primary key,
    full_name varchar(100) not null,
    dob date not null,
    gender enum ('male','female','other'),
    phone varchar(15) not null unique,
    address varchar(200) not null
);

create table doctors (
	doctor_id varchar(10) primary key,
    full_name varchar(100) not null,
    specialization varchar(50) not null,
    year_of_experience int check(year_of_experience >= 0),
    consultation_fee decimal(10, 2) not null check(consultation_fee >=0)
);

create table appointments (
	appointment_id int primary key,
    patient_id varchar(10),
    foreign key(patient_id) references patient(patient_id),
    doctor_id varchar(10),
    foreign key(doctor_id) references doctor(doctor_id),
    appointment_date timestamp not null,
    status enum ('scheduled','completed','cancelled')
);

create table payments (
	payment_id int primary key,
    appointment_id int unique,
    foreign key(appointment_id) references appointment(appointment_id),
    payment_method varchar(50) not null,
    payment_date timestamp default current_timestamp,
    amount decimal(10, 2) not null check(amount >= 0)
);

insert into patients (patient_id, full_name, dob, gender, phone, address) values
('P001', 'Nguyen Van An', '1995-03-15','male', '0912345678', 'Hanoi, Vietnam'),
('P002', 'Tran Thi Binh', '1998-07-22', 'female', '0923456789', 'Ho Chi Minh, Vietnam'),
('P003', 'Le Minh Chau', '2000-12-05', 'other', '0934567890', 'Da Nang, Vietnam'),
('P004', 'Pham Hoang Duc', '1987-09-10', 'male', '0945678901', 'Can Tho, Vietnam'),
('P005', 'Vu Thi Hoa', '1992-01-28', 'female', '0956789012', 'Hai Phong, Vietnam');

insert into doctors (doctor_id, full_name, specialization, year_of_experience, consultation_fee) values
('D001', 'Nguyen Van Minh', 'Nội', '10', '500.00'),
('D002', 'Tran Thi Lan', 'Ngoại', '15', '700.00'),
('D003', 'Le Hoang Nam', 'Nhi', '8', '400.00'),
('D004', 'Pham Quang Huy', 'Tim mạch', '20', '900.00'),
('D005', 'Vu Thi Mai', 'Da liễu', '5', '350.00'),
('D006', 'Nguyen Thanh Tung', 'Thần kinh', '12', '800.00'),
('D007', 'Do Minh Khoa', 'Chấn thương', '7', '450.00'),
('D008', 'Bui Ngoc Anh', 'Sản khoa', '18', '850.00');

insert into appointments (appointment_id, patient_id, doctor_id, appointment_date, status) values
('1', 'P001', 'D001', '2025-03-01 08:00:00', 'completed'),
('2', 'P002', 'D002', '2025-03-01 09:30:00', 'completed'),
('3', 'P003', 'D003', '2025-03-02 10:00:00', 'scheduled'),
('4', 'P004', 'D004', '2025-03-02 14:00:00', 'completed'),
('5', 'P005', 'D005', '2025-03-03 15:30:00', 'cancelled');

insert into payments (payment_id, appointment_id, payment_method, payment_date, amount) values
('1', '1', 'cash', '2025-03-01 08:45:00', '500.00'),
('2', '2', 'credit card', '2025-03-01 10:00:00', '700.00'),
('3', '3', 'bank transfer', '2025-03-02 15:00:00', '900.00'),
('4', '4', 'credit card', '2025-03-04 11:00:00', '700.00'),
('5', '5', 'cash', '2025-03-05 14:00:00', '850.00');

update patients
set phone = '0999888777'
where patient_id = 'P003';

update doctors
set year_of_experience = year_of_experience + 1,
    consultation_fee = consultation_fee * 1.2
where doctor_id = 'D001';

delete from appointments
where status = 'cancelled'
and appointment_date < '2025-03-01';

select doctor_id, full_name, specialization
from doctors
where year_of_experience > 5;

select patient_id, full_name, phone
from patients
where full_name like '%Nguyen%';

select appointment_id, appointment_date, status
from appointments
order by appointment_date asc;

select *
from payments
where payment_method = 'cash'
limit 3;

select doctor_id, full_name
from doctors
limit 3 offset 1;

select a.appointment_id, p.full_name as patient_name, d.full_name as doctor_name, a.status
from appointments a
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id = d.doctor_id
where a.status = 'completed';

select d.doctor_id, d.full_name, a.appointment_id
from doctors d
left join appointments a
on d.doctor_id = a.doctor_id;
    
select payment_method, sum(amount) as total_revenue
from payments
group by payment_method;

select d.doctor_id, d.full_name, count(a.appointment_id) as total_appointments
from doctors d
join appointments a
on d.doctor_id = a.doctor_id
group by d.doctor_id, d.full_name
having count(a.appointment_id) >= 2;

select doctor_id, full_name, consultation_fee
from doctors
where consultation_fee >
(select avg(consultation_fee) from doctors);