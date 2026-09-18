alter table usuarios 
add column especialidad_contador UUID references especialidad_contador(id);
