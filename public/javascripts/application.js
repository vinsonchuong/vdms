function in_cs(id){
  if (id == "filter_ai") { return true;}
  if (id == "filter_arc") { return true;}
  if (id == "filter_dbms") { return true;}
  if (id == "filter_gr") { return true;}
  if (id == "filter_hci") { return true;}
  if (id == "filter_osnt") { return true;}
  if (id == "filter_ps") { return true;}
  if (id == "filter_sci") { return true;}
  if (id == "filter_sec") { return true;}
  if (id == "filter_thy") { return true;}
  if (id == "filter_des") { return true;}
  if (id == "filter_ene") { return true;}
  if (id == "filter_educ") { return true;}
  if (id == "filter_bio") { return true;}
  return false;
}

function in_ee(id){
  if (id == "filter_comnet") {return true;}
  if (id == "filter_cir") {return true;}
  if (id == "filter_des") {return true;}
  if (id == "filter_ene") {return true;}
  if (id == "filter_inc") {return true;}
  if (id == "filter_mems") {return true;}
  if (id == "filter_phy") {return true;}
  if (id == "filter_sp") {return true;}
  if (id == "filter_educ") {return true;}
  if (id == "filter_bio") {return true;}
  return false;
}

function select_cs(form){
  count = form.elements.length;
    for (i = 0; i < count; i++){
      if(form.elements[i].checked == 0 && in_cs(form.elements[i].id)){
        form.elements[i].checked = 1; 
      }
    }
}

function select_ee(form){
  count = form.elements.length;
    for (i = 0; i < count; i++){
      if(form.elements[i].checked == 0 && in_ee(form.elements[i].id)){
        form.elements[i].checked = 1; 
      }
    }
}

function unselect_all(form){
  count = form.elements.length;
    for (i = 0; i < count; i++){
      if(form.elements[i].checked == 1){
        form.elements[i].checked = 0; 
      }
    }
}
