//set up the particle system
global.partsys_fire = part_system_create();
part_system_depth(global.partsys_fire,0);
//set up the particle type
global.part_fire = part_type_create(); //basic fire particle
    //how it looks
    part_type_sprite(global.part_fire,spr_fire,0,0,1);
    part_type_size(global.part_fire,2,3,-.02,0);
    part_type_orientation(global.part_fire,0,360,2,0,0);
    part_type_color3(global.part_fire,global.fireColor1,global.fireColor1,global.fireColor2);
    part_type_alpha3(global.part_fire,.25,1,0);
    part_type_blend(global.part_fire,1);
    //how it moves
    part_type_direction(global.part_fire,85,95,0,0);
    part_type_speed(global.part_fire,5,15,0,0);
    //how long it lasts
    part_type_life(global.part_fire,25,35);
