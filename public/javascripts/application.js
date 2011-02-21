// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function is_CS_area(id){
  if (id == "rank_admits_areas_AI"){ return true;}
  if (id == "rank_admits_areas_ARC"){ return true;}
  if (id == "rank_admits_areas_DBMS"){ return true;}
  if (id == "rank_admits_areas_GR"){ return true;}
  if (id == "rank_admits_areas_HCI"){ return true;}
  if (id == "rank_admits_areas_OSNT"){ return true;}
  if (id == "rank_admits_areas_PS"){ return true;}
  if (id == "rank_admits_areas_SCI"){ return true;}
  if (id == "rank_admits_areas_SEC"){ return true;}
  if (id == "rank_admits_areas_THY"){ return true;}
  if (id == "rank_admits_areas_DES"){ return true;}
  if (id == "rank_admits_areas_ENE"){ return true;}
  if (id == "rank_admits_areas_EDUC"){ return true;}
  if (id == "rank_admits_areas_BIO"){ return true;} 
  return false;
}

function is_EE_area(id){
  if (id == "rank_admits_areas_COMNET"){ return true;}
  if (id == "rank_admits_areas_CIR"){ return true;}
  if (id == "rank_admits_areas_DES"){ return true;}
  if (id == "rank_admits_areas_ENE"){ return true;}
  if (id == "rank_admits_areas_INC"){ return true;}
  if (id == "rank_admits_areas_MEMS"){ return true;}
  if (id == "rank_admits_areas_PHY"){ return true;}
  if (id == "rank_admits_areas_SP"){ return true;}
  if (id == "rank_admits_areas_EDUC"){ return true;}
  if (id == "rank_admits_areas_BIO"){ return true;}
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