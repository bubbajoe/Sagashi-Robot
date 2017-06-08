#define ls_system_init
/* --- Before creating .gex, remove all these comments!
    Variables:
        __ls_surface_final -> Holds list of surfaces. Usually only 1, but you can add views so it needs one per view.
        
        __ls_draw_mode  -> 0 = dull, 1 = normal, 2 = extra vivid (CHECK CONSTANTS)
        __ls_isenabled  -> Toggles the lighting system.
        __ls_ambient    -> Ambient background color
        __ls_shadowcaps -> Whether or not to draw caps over shadow objects.
        
        __ls_list_light_properties -> Holds a list of list id's for each light. Properties in the contained
                                      list are as follows (NOTE: id's of their LISTS are passed as the light id!).
                                      Values:
                                            x
                                            y
                                            radius
                                            spread
                                            rot
                                            precision
                                            static
                                            surfaceid -> Not an argument, creates a surface for the light.
                                            
        __ls_list_shadow_shapes -> Holds a list of grids, each grid holding position of each point in polar coords. 
        __ls_list_shadow_positions -> Holds ds_lists that contain x,y, and shadowshape ID.
        
        __ls_penumbra_s -> holds ID of imported sprite that is the penumbra.
*/
globalvar __ls_surface_finals,__ls_attached_views;
    __ls_surface_finals=ds_list_create();
    __ls_attached_views=ds_list_create();

globalvar __ls_draw_mode,__ls_isenabled,__ls_ambient,__ls_shadowcaps;
    __ls_draw_mode=ls_dm_normal;
    __ls_isenabled=false;
    __ls_ambient=c_black;
    __ls_shadowcaps=true;
    
globalvar __ls_list_light_properties;
    __ls_list_light_properties=ds_list_create();
    
globalvar __ls_list_shadow_shapes,__ls_list_shadow_positions;
    __ls_list_shadow_shapes=ds_list_create();
    __ls_list_shadow_positions=ds_list_create();
    
globalvar __ls_penumbra_s;
if (file_exists(temp_directory+"\penumbra_s.png"))
    __ls_penumbra_s=sprite_add(temp_directory+"\penumbra_s.png",0,0,0,0,0);
else
    __ls_penumbra_s=sprite_add(working_directory+"\penumbra_s.png",0,0,0,0,0);


#define ls_system_free
/*
    Clears the entire system. Should be called at the end of the game.
*/
var size=ds_list_size(__ls_surface_finals);
for (var i=0;i<size;++i)
{
    surface_free(ds_list_find_value(__ls_surface_finals,i));
}
ds_list_destroy(__ls_surface_finals);

__ls_list_light_surface=ds_list_create();
__ls_list_light_properties=ds_list_create();

size=ds_list_size(__ls_list_light_surface);
for (var i=0;i<size;++i)
{
    surface_free(ds_list_find_value(__ls_list_light_surface,i));
}
ds_list_destroy(__ls_list_light_surface);

var size=ds_list_size(__ls_list_light_properties);
for (var i=0;i<size;++i)
{
    ds_list_destroy(ds_list_find_value(__ls_list_light_properties,i));
}
ds_list_destroy(__ls_list_light_properties);

var size=ds_list_size(__ls_list_shadow_shapes);
for (var i=0;i<size;++i)
{
    ds_grid_destroy(ds_list_find_value(__ls_list_shadow_shapes,i));
}
ds_list_destroy(__ls_list_shadow_shapes);

var size=ds_list_size(__ls_list_shadow_positions);
for (var i=0;i<size;++i)
{
    ds_list_destroy(abs(ds_list_find_value(__ls_list_shadow_positions,i)));
}
ds_list_destroy(__ls_list_shadow_positions);

ds_list_destroy(__ls_attached_views);


#define ls_angledif
return ((((argument0 - argument1)%360)+540)%360) - 180;

#define __ls_system_update
/*
    Takes care of drawing things to the surfaces themselves.
*/
if (!__ls_isenabled||ds_list_empty(__ls_attached_views)) exit;

draw_set_alpha(1);
draw_set_color(c_white);

var size=ds_list_size(__ls_list_light_properties);
for (var i=0;i<size;++i)
{
    var ID=ds_list_find_value(__ls_list_light_properties,i);
    if (ds_list_find_value(ID,7)==false)
        ls_light_surface_draw(ID);
}

draw_set_blend_mode(bm_normal);

var surfaces=ds_list_size(__ls_attached_views);
for (var i=0;i<surfaces;++i)
{
    var ID=ds_list_find_value(__ls_attached_views,i);
    var xoff=0,yoff=0;
    if (ID!=-1)
    {
        xoff=-view_xview[0];
        yoff=-view_yview[0];
    }
    
    var surf=ds_list_find_value(__ls_surface_finals,i);
    if (!surface_exists(surf))
    {
        if (ID>=0)
            surf=surface_create(view_wview[ID],view_hview[ID]);
        else
            surf=surface_create(room_width,room_height);
        ds_list_replace(__ls_surface_finals,i,surf);
    }
    
    surface_set_target(surf);
    draw_clear(__ls_ambient);
    
    if (__ls_draw_mode<2)
        draw_set_blend_mode_ext(bm_one,bm_inv_src_color);
    else 
        draw_set_blend_mode(bm_add);
    
    for (var i=0;i<size;++i)
    {
        var ID=ds_list_find_value(__ls_list_light_properties,i);
        var rad=ds_list_find_value(ID,2);
        draw_surface_ext(ds_list_find_value(ID,ds_list_size(ID)-1),ds_list_find_value(ID,0)-rad+xoff,ds_list_find_value(ID,1)-rad+yoff,1,1,0,ds_list_find_value(ID,5),1);
    }
}

surface_reset_target();
draw_set_blend_mode(bm_normal);


#define ls_system_draw
/*
    Draws the actual surface onto the screen.
    argument0 - Update system
    argument1 - Debug
*/
if (!__ls_isenabled||ds_list_empty(__ls_attached_views)) exit;
if (argument0)
    __ls_system_update();

draw_set_alpha(1);
draw_set_color(c_white);
if (argument1)
    draw_set_blend_mode(bm_normal);
else
{
    if (__ls_draw_mode>0)
        draw_set_blend_mode_ext(bm_dest_color,bm_src_color);
    else
        draw_set_blend_mode_ext(bm_dest_color,bm_zero);
}
    
var surfaces=ds_list_size(__ls_attached_views);
for (var i=0;i<surfaces;++i)
{
    var ID=ds_list_find_value(__ls_attached_views,i);
    if (ID==-1)
        draw_surface(ds_list_find_value(__ls_surface_finals,i),0,0);
    else
    {
        if (view_current==ID)
            draw_surface_ext(ds_list_find_value(__ls_surface_finals,i),view_xview[ID],view_yview[ID],1,1,0,c_white,1);
    }
    
}    
    
draw_set_blend_mode(bm_normal);

#define ls_system_properties
/*
    Arguments:
        0 - enabled
        1 - lighting mode (ls_dm_dull/normal/vivid)
        2 - ambient color
        3 - draws shadow caps
*/
__ls_isenabled=argument0;
__ls_draw_mode=argument1;
__ls_ambient=argument2;
__ls_shadowcaps=argument3;

#define ls_view_attach
/*
    Attachs a view to the system to draw on
    Argument is the view
*/

if (ds_list_find_index(__ls_attached_views,argument0)==-1)
{
    ds_list_add(__ls_attached_views,argument0);
    ds_list_add(__ls_surface_finals,surface_create(view_wview[argument0],view_hview[argument0]));
    return true;
}
return false;

#define ls_view_detach
var index=ds_list_find_index(__ls_attached_views,argument0);
if (index!=-1)
{
    ds_list_delete(__ls_attached_views,index);
    surface_free(ds_list_find_value(__ls_surface_finals,index));
    ds_list_delete(__ls_surface_finals,index);
    return true;
}
return false;


#define ls_view_recalculate
/*
    Recalculates the surface sizes for each view. 
*/
var size=ds_list_size(__ls_attached_views);
if (size==0||(ds_list_find_index(__ls_attached_views,-1)&&size==1))
    return false;

for (var i=0;i<size;++i)
{
    var ID=ds_list_find_value(__ls_attached_views,i);
    surface_free(ds_list_find_value(__ls_surface_finals,i));
}

for (var i=0;i<size;++i)
{
    var ID=ds_list_find_value(__ls_attached_views,i);
    if (ID>=0)
        ds_list_replace(__ls_surface_finals,i,surface_create(view_wview[ID],view_yview[ID]));
    else
        ds_list_replace(__ls_surface_finals,i,surface_create(room_width,room_height));
}

return true;

#define ls_noview_attach
/*
    Attaches a "noview" or the entire room to be drawn on on every view.
*/

if (ds_list_find_index(__ls_attached_views,-1)==-1)
{
    ds_list_add(__ls_attached_views,-1);
    ds_list_add(__ls_surface_finals,surface_create(room_width,room_height));
    return true;
}
return false;


#define ls_noview_detach
var index=ds_list_find_index(__ls_attached_views,-1);
if (index!=-1)
{
    ds_list_delete(__ls_attached_views,index);
    surface_free(ds_list_find_value(__ls_surface_finals,index));
    ds_list_delete(__ls_surface_finals,index);
    return true;
}
return false;


#define ls_light_create
/*Arguments
    x
    y
    radius
    spread
    rot
    color
    precision
    static
    shadows
*/
var lightid=ds_list_create();
for (var i=0;i<=8;++i)
    ds_list_add(lightid,argument[i]);

/*Following line is to avoid an annoying GM feature.*/  
argument4=argument4;
argument5=argument5;
argument6=argument6; 
argument8=argument8;    

ds_list_add(__ls_list_light_properties,lightid);
ds_list_add(lightid,surface_create(argument2*2,argument2*2));
if (argument7 == true)
    ls_light_surface_draw(lightid);
return lightid;

#define ls_light_destroy
/*
    Arguments:
    1 -> light id
    
    Returns:
    if deleting succeded.
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to destroy non-existing light: "+string(argument0),1);
    return false;
}

surface_free(ds_list_find_value(argument0,ds_list_size(argument0)-1));
ds_list_destroy(argument0);
ds_list_delete(__ls_list_light_properties,val);

return true;


#define ls_light_set_pos
/*Arguments
    0 - id
    1 - x
    2 - y
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

if (ls_light_get_static(argument0))
{
    show_error("Lighting Studio Error:
---
Cannot change static light: "+string(argument0),0);
}


ds_list_replace(argument0,0,argument1);
ds_list_replace(argument0,1,argument2);


#define ls_light_set_rot
/*Arguments
    0 - id
    1 - rot
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

if (ls_light_get_static(argument0))
{
    show_error("Lighting Studio Error:
---
Cannot change static light: "+string(argument0),0);
}

ds_list_replace(argument0,4,argument1);


#define ls_light_set_static
/*Arguments
    0 - id
    1 - static
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

ds_list_replace(argument0,7,argument1);
if (argument1==true)
    ls_light_surface_draw(argument0);

#define ls_light_set_spread
/*Arguments
    0 - id
    1 - spread
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

if (ls_light_get_static(argument0))
{
    show_error("Lighting Studio Error:
---
Cannot change static light: "+string(argument0),0);
}

ds_list_replace(argument0,3,argument1);

#define ls_light_set_color
/*Arguments
    0 - id
    1 - color
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

if (ls_light_get_static(argument0))
{
    show_error("Lighting Studio Error:
---
Cannot change static light: "+string(argument0),0);
}

ds_list_replace(argument0,5,argument1);


#define ls_light_set_shadows
/*Arguments
    0 - id
    1 - shadows on (bool)
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

ds_list_replace(argument0,8,argument1);

#define ls_light_get_x
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,0);


#define ls_light_get_y
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,1);

#define ls_light_get_rot
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,4);


#define ls_light_get_static
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,7);


#define ls_light_get_spread
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,3);

#define ls_light_get_color
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,5);

#define ls_light_get_shadows
/*Arguments
    0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to grab properties of non-existing light: "+string(argument0),1);
exit;
}

return ds_list_find_value(argument0,8);


#define ls_light_manual_update
/* 
    Updates a light manually.
    Argument 0 - id
*/
var val=ds_list_find_index(__ls_list_light_properties,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to change non-existing light: "+string(argument0),1);
exit;
}

ls_light_surface_draw(argument0);

#define ls_light_surface_draw
/*
    Arguments:
    0 -> id
*/
draw_set_alpha(1);
draw_set_color(c_white);

var surf=ds_list_find_value(argument0,ds_list_size(argument0)-1);

var rad=ds_list_find_value(argument0,2),
    dir=ds_list_find_value(argument0,4),
    sprd=ds_list_find_value(argument0,3),
    prec=ds_list_find_value(argument0,6);
    
/*Make sure the surface exists.*/
if (!surface_exists(surf))
{
    surf=surface_create(rad*2,rad*2);
    ds_list_replace(argument0,ds_list_size(argument0)-1,surf);
}

draw_set_blend_mode(bm_normal);
surface_set_target(surf);
draw_clear_alpha(c_black,1);
draw_set_color(c_white);
    
draw_primitive_begin_texture(pr_trianglelist,sprite_get_texture(__ls_penumbra_s,0));

var soft_edge=false;
if (sprd<360)
    soft_edge=true;
    
    draw_vertex_texture_color(rad,rad,0,1,c_white,1);
    draw_vertex_texture_color(rad+cos(pi/180*(dir-sprd/2))*rad,rad-sin(pi/180*(dir-sprd/2))*rad,soft_edge,0,c_black,1);
    draw_vertex_texture_color(rad+cos(pi/180*(dir-sprd/2+sprd/prec))*rad,rad-sin(pi/180*(dir-sprd/2+sprd/prec))*rad,0,0,c_black,1);
for (var i=dir-sprd/2+sprd/prec;i<=dir+sprd/2-sprd/prec;i+=sprd/prec)
{
    draw_vertex_texture_color(rad,rad,0,1,c_white,1);
    draw_vertex_texture_color(rad+cos(pi/180*i)*rad,rad-sin(pi/180*i)*rad,0,0,c_black,1);
    draw_vertex_texture_color(rad+cos(pi/180*(i+sprd/prec))*rad,rad-sin(pi/180*(i+sprd/prec))*rad,0,0,c_black,1);
}

draw_vertex_texture_color(rad,rad,0,1,c_white,1);
draw_vertex_texture_color(rad+cos(pi/180*(dir+sprd/2-sprd/prec))*rad,rad-sin(pi/180*(dir+sprd/2-sprd/prec))*rad,0,0,c_black,1);
draw_vertex_texture_color(rad+cos(pi/180*(dir+sprd/2))*rad,rad-sin(pi/180*(dir+sprd/2))*rad,soft_edge,0,c_black,1);

draw_primitive_end();

/*Draws the shadows on this mask now:*/
draw_set_color(c_white);

var size=ds_list_size(__ls_list_shadow_positions);
var light_x=ds_list_find_value(argument0,0),
    light_y=ds_list_find_value(argument0,1);
var _shads=ds_list_find_value(argument0,8);

for (var i=0;i<size;++i)
{
    if (!_shads) break;/*If shadows are disabled, we quit here.*/
    /*If culling is enabed, culling will be negative.*/
    var cullingon=ds_list_find_value(__ls_list_shadow_positions,i);
    var ID=ds_list_find_value(abs(cullingon),0),
        X=ds_list_find_value(abs(cullingon),1),
        Y=ds_list_find_value(abs(cullingon),2);
    cullingon=sign(cullingon);
        
    var points=ds_grid_height(ID)-1;
    
    /*By changing from strip to list, it can make everything a single polygon.
      This is faster in the long run, if there are many shadow objects (Also w/ shadow caps).
      It would be best outside the for i loop, but it is causing issues.*/
        draw_primitive_begin_texture(pr_trianglelist,sprite_get_texture(__ls_penumbra_s,0)); 
        
        /*Finds the 'center' of the shape. Should be fine as long as it isn't concave.*/
        var cX=0,cY=0;
        for (var j=0; j<points; ++j)
        {
            var pt=ds_grid_get(ID,0,j),
                pr=ds_grid_get(ID,1,j);
            cX+=X+cos(pi/180*pt)*pr;
            cY+=Y-sin(pi/180*pt)*pr;
        }
        cX/=points;
        cY/=points;

        /*Vars essentially for culling. But they are used
          as a for-loop bound as well.*/
        var l_most=0,
            r_most=0,
            l_angle=0,
            r_angle=0,
            lightinside=true;
                
        if (cullingon<0)
        {
            /*Calculate culling:
            ------------------*/
            
            var buildir=0;/*Will determine the defining direction (clock/counterclock)*/
            var lastpx=X+cos(pi/180*ds_grid_get(ID,0,points-1))*ds_grid_get(ID,1,points-1),
                lastpy=Y-sin(pi/180*ds_grid_get(ID,0,points-1))*ds_grid_get(ID,1,points-1);
            
    
            for (var j=0;j<points;++j)
            {
                var pt=ds_grid_get(ID,0,j),
                    pr=ds_grid_get(ID,1,j),
                    px=X+cos(pi/180*pt)*pr,
                    py=Y-sin(pi/180*pt)*pr;
                var a;
                a=ls_angledif(point_direction(light_x,light_y,cX,cY),point_direction(light_x,light_y,px,py));
                if (a>=l_angle)
                {
                    l_most=j;
                    l_angle=a;
                }
                if (a<=r_angle)
                {
                    r_most=j;
                    r_angle=a;
                }
                
                /*Determines direction. + is clockwise, - is counterclockwise*/
                buildir+=ls_angledif(point_direction(cX,cY,lastpx,lastpy),point_direction(cX,cY,px,py));
                
                if (__ls_linesintersect(light_x,light_y,cX,cY,px,py,lastpx,lastpy))
                    lightinside=false;
                
                lastpx=px;
                lastpy=py;
            }
            /*------------------*/  
            /*Starts worrying about shadows:*/
            var _lmost,_rmost;
            if (buildir>=0)/*Clockwise*/
            {
                _lmost=l_most;
                _rmost=r_most;
            }
            else
            {
                _lmost=r_most;
                _rmost=l_most;
            }
            var addone=false;
        }
        else
        {
            /*No culling, we neet to set the bounds properly.*/
            _rmost=-1;
            _lmost=points-1;
            /*We don't want the screen wiped when no culling is there.*/
            
            lightinside=false;
            var addone=true;
        }
        
        if (lightinside==true)
        {
            /*We just clear the screen to black, to save some polies.*/
            draw_clear(c_black);
        }
        else
        for (j=(_rmost+1)%(points+addone);j!=(_lmost+1)%(points+addone);j=(j+1)%(points+addone))
        {
                var jx=j-1;
                if (jx<0)
                    jx+=points;
                var pt=ds_grid_get(ID,0,j),
                    pr=ds_grid_get(ID,1,j),
                    pt_p=ds_grid_get(ID,0,jx),
                    pr_p=ds_grid_get(ID,1,jx);

            
                var dir_p=point_direction(light_x,light_y,X+cos(pi/180*pt_p)*pr_p,Y-sin(pi/180*pt_p)*pr_p),
                    dir=point_direction(light_x,light_y,X+cos(pi/180*pt)*pr,Y-sin(pi/180*pt)*pr);
                    
                /*FIXED: I changed some pr_p's to 10's in the multiplication. It was causing issues for 
                         points with positions 0,0 where pr_p would be 0. This may not be as precise, but since
                         it draws OUT of the layer, there should be no visual difference.*/
                    if (point_distance(light_x,light_y,X+cos(pi/180*pt_p)*pr_p,Y-sin(pi/180*pt_p)*pr_p)<=rad*1.5) 
                    { 
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt_p)*pr_p,Y-(light_y-rad)-sin(pi/180*pt_p)*pr_p,1,1);
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt_p)*pr_p + cos(pi/180*dir_p)*10*(rad*2),Y-(light_y-rad)-sin(pi/180*pt_p)*pr_p - sin(pi/180*dir_p)*10*(rad*2),1,0);
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt)*pr,Y-(light_y-rad)-sin(pi/180*pt)*pr,1,1);
                    }
                    if (point_distance(light_x,light_y,X+cos(pi/180*pt)*pr,Y-sin(pi/180*pt)*pr)<=rad*1.5) 
                    { 
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt_p)*pr_p + cos(pi/180*dir_p)*10*(rad*2),Y-(light_y-rad)-sin(pi/180*pt_p)*pr_p - sin(pi/180*dir_p)*10*(rad*2),1,0);
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt)*pr,Y-(light_y-rad)-sin(pi/180*pt)*pr,1,1);
                        draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt)*pr + cos(pi/180*dir)*10*(rad*2),Y-(light_y-rad)-sin(pi/180*pt)*pr - sin(pi/180*dir)*10*(rad*2),1,0);
                    }
        }
        
        /*We draw the shadow caps if enabled.
          Note: This connects the ends automatically!*/
        if (__ls_shadowcaps)
        {
            if (!lightinside)
            for (j=1;j<=points;++j)
            {
                    var jx=j-1;
                    if (jx<0)
                        jx+=points;
                    var pt=ds_grid_get(ID,0,j%points),
                        pr=ds_grid_get(ID,1,j%points),
                        pt_p=ds_grid_get(ID,0,jx),
                        pr_p=ds_grid_get(ID,1,jx);
                    /*This is causing an ugly issue if the origin is OUTSIDE the shape.*/
                    draw_vertex_texture(cX-(light_x-rad),cY-(light_y-rad),1,1);
                    draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt_p)*pr_p,Y-(light_y-rad)-sin(pi/180*pt_p)*pr_p,1,0);
                    draw_vertex_texture(X-(light_x-rad)+cos(pi/180*pt)*pr,Y-(light_y-rad)-sin(pi/180*pt)*pr,1,0);
            }
        }
        
    draw_primitive_end();
}
surface_reset_target();


#define ls_shadow_create
/*
    No arguments, it returns the id of the shadow.
*/

var ID=ds_grid_create(2,1);
ds_grid_clear(ID,-1);
ds_list_add(__ls_list_shadow_shapes,ID);
return ID;

#define ls_shadow_destroy
/*
    Argument0 -> ID
*/

var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to destroy non-existing shadow: "+string(argument0),1);
    exit;
}

ds_grid_destroy(ds_list_find_value(__ls_list_shadow_shapes,val));
ds_list_delete(__ls_list_shadow_shapes,val);


#define ls_shadow_addpoint_polar
/*
    Arguments:
    0- shadow ID
    1- angle
    2- radius
*/
var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to add point to non-existing shadow: "+string(argument0),1);
    return -1;
}

var mygrid=argument0;
var height=ds_grid_height(mygrid);
    
ds_grid_set(mygrid,0,height-1,argument1);
ds_grid_set(mygrid,1,height-1,argument2);

ds_grid_resize(mygrid,2,height+1);

return height-1;

#define ls_shadow_addpoint_cartesian
/*
    Arguments:
    0- shadow ID
    1- x
    2- y
*/
var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to add point to non-existing shadow: "+string(argument0),1);
    return -1;
}

var mygrid=argument0;
var height=ds_grid_height(mygrid);
    
ds_grid_set(mygrid,0,height-1,point_direction(0,0,argument1,argument2));
ds_grid_set(mygrid,1,height-1,point_distance(0,0,argument1,argument2));

ds_grid_resize(mygrid,2,height+1);

return height-1;

#define ls_shadow_setpoint_polar
/*
    Arguments:
    0- shadow ID
    1- point ID
    2- angle
    3- radius
*/
var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to set point for non-existing shadow: "+string(argument0),1);
    exit;
}

var mygrid=argument0;
    
ds_grid_set(mygrid,0,argument1-1,argument2);
ds_grid_set(mygrid,1,argument1-1,argument3);

#define ls_shadow_setpoint_cartesian
/*
    Arguments:
    0- shadow ID
    1- point ID
    2- x
    3- y
*/
var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to set point for non-existing shadow: "+string(argument0),1);
    exit;
}

var mygrid=argument0;
    
ds_grid_set(mygrid,0,argument1-1,point_direction(0,0,argument2,argument3));
ds_grid_set(mygrid,1,argument1-1,point_distance(0,0,argument2,argument3));

#define ls_shadow_attach_pos
/*
    Arguments:
    0- ID
    1- x
    2- y
    3- culling
    
    Returns ID of this shape.
*/

var ID=ds_list_create();
ds_list_add(ID,argument0);
ds_list_add(ID,argument1);
ds_list_add(ID,argument2);
if (argument3>0)
    ds_list_add(__ls_list_shadow_positions,-ID);
else
    ds_list_add(__ls_list_shadow_positions,ID);

return ID;

#define ls_shadow_detach_pos
/*
    Arguments:
    0- ID
*/
var val=ds_list_find_index(__ls_list_shadow_positions,argument0);
if (val==-1)
    val=ds_list_find_index(__ls_list_shadow_positions,-argument0);/*For culling.*/
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to destroy non-existing shadow position: "+string(argument0),1);
    return false;
}

ds_list_destroy(argument0);
ds_list_delete(__ls_list_shadow_positions,val);

return true;

#define ls_shadow_modify_pos
/*
    Arguments:
    0- ID
    1- x
    2- y
*/
var val=ds_list_find_index(__ls_list_shadow_positions,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to modify non-existing shadow position: "+string(argument0),1);
    return false;
}

ds_list_replace(argument0,1,argument1);
ds_list_replace(argument1,2,argument2);

return true;

#define ls_shadow_clearpoints
/*
    Arguments:
    0- Shadow ID
*/

var val=ds_list_find_index(__ls_list_shadow_shapes,argument0);
if (val==-1)
{
    show_error("Lighting Studio Error:
---
Trying to clear points of non-existing shadow: "+string(argument0),1);
    return false;
}

ds_grid_resize(argument0,2,1);
ds_grid_clear(argument0,-1);

return true;


#define __ls_linesintersect
/*  x1,y1,x2,y2
    x3,y3,x4,y4*/
var aX=argument0,
    aY=argument1,
    bX=argument2,
    bY=argument3,
    cX=argument4,
    cY=argument5,
    dX=argument6,
    dY=argument7;

var denominator = ((bX - aX) * (dY - cY)) - ((bY - aY) * (dX - cX));
var numerator1 = ((aY - cY) * (dX - cX)) - ((aX - cX) * (dY - cY));
var numerator2 = ((aY - cY) * (bX - aX)) - ((aX - cX) * (bY - aY));


if (denominator == 0) 
    return numerator1 == 0 && numerator2 == 0;

var r = numerator1 / denominator;
var s = numerator2 / denominator;
 
return (r >= 0 && r <= 1) && (s >= 0 && s <= 1);

