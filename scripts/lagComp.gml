x = view_xview + (view_wview/2);
y = view_yview + (view_hview/2);
instance_deactivate_region(view_xview-32,view_yview-32,view_wview+64,view_hview+64,0,1);
instance_activate_region(view_xview-16,view_yview-16,view_wview+32,view_hview+32,1);
