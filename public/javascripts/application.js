// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function is_CS_area(id){
  if (id == "rank_admits_areas_ai"){ return true;}
  if (id == "rank_admits_areas_arc"){ return true;}
  if (id == "rank_admits_areas_dbms"){ return true;}
  if (id == "rank_admits_areas_gr"){ return true;}
  if (id == "rank_admits_areas_hci"){ return true;}
  if (id == "rank_admits_areas_osnt"){ return true;}
  if (id == "rank_admits_areas_ps"){ return true;}
  if (id == "rank_admits_areas_sci"){ return true;}
  if (id == "rank_admits_areas_sec"){ return true;}
  if (id == "rank_admits_areas_thy"){ return true;}
  if (id == "rank_admits_areas_des"){ return true;}
  if (id == "rank_admits_areas_ene"){ return true;}
  if (id == "rank_admits_areas_educ"){ return true;}
  if (id == "rank_admits_areas_bio"){ return true;}
  return false;
}

function is_EE_area(id){
  if (id == "rank_admits_areas_comnet"){ return true;}
  if (id == "rank_admits_areas_cir"){ return true;}
  if (id == "rank_admits_areas_des"){ return true;}
  if (id == "rank_admits_areas_ene"){ return true;}
  if (id == "rank_admits_areas_inc"){ return true;}
  if (id == "rank_admits_areas_mems"){ return true;}
  if (id == "rank_admits_areas_phy"){ return true;}
  if (id == "rank_admits_areas_sp"){ return true;}
  if (id == "rank_admits_areas_educ"){ return true;}
  if (id == "rank_admits_areas_bio"){ return true;}
  return false;
}

function CheckAllCS(form){
  count = form.elements.length;
    for (i=0; i < count; i++){
      if(form.elements[i].checked == 0 && is_CS_area(form.elements[i].id)){
        form.elements[i].checked = 1; 
      }
    }
}

function CheckAllEE(form){
  count = form.elements.length;
    for (i=0; i < count; i++){
      if(form.elements[i].checked == 0 && is_EE_area(form.elements[i].id)){
        form.elements[i].checked = 1; 
      }
    }
}

function UncheckAll(form){
  count = form.elements.length;
    for (i=0; i < count; i++){
      if(form.elements[i].checked == 1){
        form.elements[i].checked = 0; 
      }
    }
}