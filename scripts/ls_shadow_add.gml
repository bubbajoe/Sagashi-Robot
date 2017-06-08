with (obj_wall)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,32,32);
    ls_shadow_addpoint_cartesian(shadow,0,32);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_lWall)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,32,32);
    ls_shadow_addpoint_cartesian(shadow,0,32);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_uWall)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,32,32);
    ls_shadow_addpoint_cartesian(shadow,0,32);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_dWall)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,32,32);
    ls_shadow_addpoint_cartesian(shadow,0,32);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_rWall)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,32,32);
    ls_shadow_addpoint_cartesian(shadow,0,32);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_computer1)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,29,16);
    ls_shadow_addpoint_cartesian(shadow,3,16);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_computer2)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,0);
    ls_shadow_addpoint_cartesian(shadow,32,0);
    ls_shadow_addpoint_cartesian(shadow,29,16);
    ls_shadow_addpoint_cartesian(shadow,3,16);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_help1)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,0,30);
    ls_shadow_addpoint_cartesian(shadow,10,30);
    ls_shadow_addpoint_cartesian(shadow,13,27);
    ls_shadow_addpoint_cartesian(shadow,13,4);
    ls_shadow_addpoint_cartesian(shadow,10,1);
    ls_shadow_addpoint_cartesian(shadow,0,1);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}

with (obj_energy1)
{
    shadow=ls_shadow_create();
    ls_shadow_addpoint_cartesian(shadow,1,0);
    ls_shadow_addpoint_cartesian(shadow,1,11);
    ls_shadow_addpoint_cartesian(shadow,5,15);
    ls_shadow_addpoint_cartesian(shadow,26,15);
    ls_shadow_addpoint_cartesian(shadow,30,11);
    ls_shadow_addpoint_cartesian(shadow,30,0);
    myshadow=ls_shadow_attach_pos(shadow,x,y,true);
}
