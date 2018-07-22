/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function viewform(clsname,id){
    var all=document.getElementsByClassName(clsname);
    for(i=0;i<all.length;i++)
        all[i].style.display="none";
    var data=document.getElementById(id);
    data.style.display="block";
}