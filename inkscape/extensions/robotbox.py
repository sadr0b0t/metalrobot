#! /usr/bin/env python
'''
Draw box with given width, height and depth.

Use "Extensions / Modify Path / Convert to dashes" to convert dashed bend lines to CNC-friendly style.

Copyright (C) 2015 Anton Moiseev  (1i7.livejournal.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'''

import inkex
import simplestyle, sys
from simplepath import formatPath

class RobotBox(inkex.Effect):
    def __init__(self):
        inkex.Effect.__init__(self)
        self.OptionParser.add_option("-x", "--width",
                        action="store", type="float",
                        dest="width", default=62.0,
                        help="The Box Width - in the X dimension")
        self.OptionParser.add_option("-y", "--height",
                        action="store", type="float",
                        dest="height", default=38.0,
                        help="The Box Height - in the Y dimension")
        self.OptionParser.add_option("-z", "--depth",
                        action="store", type="float",
                        dest="depth", default=23.0,
                        help="The Box Depth - in the Z dimension")
        self.OptionParser.add_option("-p", "--paper-thickness",
                        action="store", type="float",
                        dest="thickness", default=1.0,
                        help="Paper thickness - important for thick carton")
        self.OptionParser.add_option("-c", "--cramp-height",
                        action="store", type="float",
                        dest="cramp_height", default=1.0,
                        help="Cramp ear height - render cramping ears and slots on the left and right walls (0 for no cramp)")
        self.OptionParser.add_option("-d", "--dash-width",
                        action="store", type="float",
                        dest="dash_width", default=5.0,
                        help="Bend line dash width")
        self.OptionParser.add_option("-s", "--dash-step",
                        action="store", type="float",
                        dest="dash_step", default=5.0,
                        help="Bend line dash step")
        self.OptionParser.add_option("-b", "--bendline-surface",
                        action="store", type="string",
                        dest="bend_surface", default="inner",
                        help="Bend line surface (innder or outer) - depends on the way you will make actual bends")
        self.OptionParser.add_option("-u", "--unit",
                        action="store", type="string",
                        dest="unit", default="mm",
                        help="The unit of dimensions")
                        
    def effect(self):

        width  = self.unittouu( str(self.options.width) + self.options.unit )
        height = self.unittouu( str(self.options.height) + self.options.unit )
        depth  = self.unittouu( str(self.options.depth) + self.options.unit )
        thickness  = self.unittouu( str(self.options.thickness) + self.options.unit )
        cramp_height  = self.unittouu( str(self.options.cramp_height) + self.options.unit )
        dash_width  = self.unittouu( str(self.options.dash_width) + self.options.unit )
        dash_step  = self.unittouu( str(self.options.dash_step) + self.options.unit )
        bend_surface  = self.options.bend_surface

        # bend correction: it makes sense when compose the box whether the bend line would
        # lay on the inner or outer surface of the thick carton
        bcorr = 0
        if bend_surface == "inner":
            bcorr = 0
        elif bend_surface == "outer":
            bcorr = thickness
        else :# "middle"
            bcorr = thickness/2

        # small ears (to be hidden inside the box borders) length
        ear1 = height / 2 - bcorr*2

        # slot width - make slots a bit thiner than ears (thickness)
        slot_width_factor = 0.8
        slot_width = thickness * slot_width_factor

        # big ears skew = ~25 degrees
        # skew_shift = depth*2/3 * tg(25)
        skew_shift = depth*2/3 * 0.47

        # render 2 cramps as 1/5 of box height with same (1/5 of height) step
        cramp_width = height/5
        
        # Generate box points
        # Details on the shape here:
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft1.svg
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft2.svg

        # points for straight lines of the left bound
        left_points = [
                # start from left bottom "ear" and go left and up
                # ear 1
                0,0,    -ear1,0, 
                -ear1,depth,    0,depth, 
                # ear 2
                0,depth+bcorr*2,    -((thickness-bcorr)+slot_width+bcorr),depth+bcorr*2,    -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2),depth+bcorr*2,    
                -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr),depth+bcorr*2,    
                -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr)-(bcorr+depth),depth+bcorr*2 
        ]

        # render cramping ears if set
        if cramp_height > 0:
            left_cramp_x = -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr)-(bcorr+depth)
        
            left_points += [
                # left cramp ear1
                left_cramp_x,(depth+bcorr*2)+cramp_width,    left_cramp_x-cramp_height,(depth+bcorr*2)+cramp_width+thickness,
                left_cramp_x-cramp_height,(depth+bcorr*2)+cramp_width*2-thickness,    left_cramp_x,(depth+bcorr*2)+cramp_width*2,
                
                # left cramp ear2
                left_cramp_x,(depth+bcorr*2)+cramp_width*3,    left_cramp_x-cramp_height,(depth+bcorr*2)+cramp_width*3+thickness,
                left_cramp_x-cramp_height,(depth+bcorr*2)+cramp_width*4-thickness,    left_cramp_x,(depth+bcorr*2)+cramp_width*4
            ]
                
                
        left_points += [
                # ear 2 finish
                -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr)-(bcorr+depth),(depth+bcorr*2)+height,    
                -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr),(depth+bcorr*2)+height,    
                -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2),(depth+bcorr*2)+height,    
                -((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2)+height,    0,(depth+bcorr*2)+height,
                # ear 3
                0,(depth+bcorr*2)+(height+bcorr*2),    -ear1,(depth+bcorr*2)+(height+bcorr*2),
                -ear1,(depth+bcorr*2)+(height+bcorr*2)+depth,    0,(depth+bcorr*2)+(height+bcorr*2)+depth,    bcorr+thickness+(thickness-bcorr),(depth+bcorr*2)+(height+bcorr*2)+depth,
                # ear 4
                (bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2),    (bcorr+thickness+(thickness-bcorr))-depth*2/3,(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+skew_shift,
                (bcorr+thickness+(thickness-bcorr))-depth*2/3,(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height-skew_shift,    (bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height
        ]
        

        # points for straight lines of the right bound
        right_base_x = bcorr+thickness+width+thickness+bcorr
        right_points = [
                # ear 7
                right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height,    right_base_x-(bcorr+thickness+(thickness-bcorr))+depth*2/3,(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height-skew_shift,
                right_base_x-(bcorr+thickness+(thickness-bcorr))+depth*2/3,(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+skew_shift,    right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2),
                # ear 8
                right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+depth,    right_base_x,(depth+bcorr*2)+(height+bcorr*2)+depth,    right_base_x+ear1,(depth+bcorr*2)+(height+bcorr*2)+depth,
                right_base_x+ear1,(depth+bcorr*2)+(height+bcorr*2),    right_base_x,(depth+bcorr*2)+(height+bcorr*2),
                # ear 9
                right_base_x,(depth+bcorr*2)+height,    right_base_x+((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2)+height,    
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2),(depth+bcorr*2)+height,    
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr),(depth+bcorr*2)+height,    
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr)+(bcorr+depth),(depth+bcorr*2)+height
        ]

        # render cramping ears if set
        if cramp_height > 0:
            right_cramp_x = right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr)+(bcorr+depth)
            right_points += [
                # right cramp ear1
                right_cramp_x,(depth+bcorr*2)+height-cramp_width,    right_cramp_x+cramp_height,(depth+bcorr*2)+height-cramp_width-thickness,
                right_cramp_x+cramp_height,(depth+bcorr*2)+height-cramp_width*2+thickness,    right_cramp_x,(depth+bcorr*2)+height-cramp_width*2,    
                
                # right cramp ear2
                right_cramp_x,(depth+bcorr*2)+height-cramp_width*3,    right_cramp_x+cramp_height,(depth+bcorr*2)+height-cramp_width*3-thickness,
                right_cramp_x+cramp_height,(depth+bcorr*2)+height-cramp_width*4+thickness,    right_cramp_x,(depth+bcorr*2)+height-cramp_width*4
            ]

        right_points += [
                # ear 9 finish
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr)+(bcorr+depth),(depth+bcorr*2),    
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr),(depth+bcorr*2),    
                right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2),(depth+bcorr*2),    
                right_base_x+((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2),    right_base_x,(depth+bcorr*2),
                # ear 10
                right_base_x,depth,    right_base_x+ear1,depth,
                right_base_x+ear1,0,    right_base_x,0
        ]

        
        bound_points = [
            [ 'M', left_points ],
            # ear 5: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            # m 0,0 c -39.88719,-0.7697 -90.44391,-0.7593 -73.26685,35.3985 11.37507,22.1855 33.21015,45.182 73.26685,46.0975 z
            [ 'L', [
                (bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2),
                -(bcorr+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)
            ] ],
            [ 'C', [
#                -39.88719,          (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+bcorr*2)-0.7697,
#                -90.44391,          (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+bcorr*2)-0.7593,
#                -73.26685,          (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+bcorr*2)+35.3985,
#                -73.26685+11.37507, (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+bcorr*2)+35.3985+22.1855,
#                -73.26685+33.21015, (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+bcorr*2)+35.3985+45.182,

                -(bcorr+(thickness-bcorr))-depth/2,     (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2),
                -(bcorr+(thickness-bcorr))-depth/10*11, (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2),
                -(bcorr+(thickness-bcorr))-depth/8*7,   (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth/16*7,
                -(bcorr+(thickness-bcorr))-depth/8*6,   (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth/16*11,
                -(bcorr+(thickness-bcorr))-depth/2,     (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth,
                -(bcorr+(thickness-bcorr)),             (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth
            ] ],
            # now go to the right and go down in reverse order
            # ear 6: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            [ 'L', [
                right_base_x+(bcorr+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth
            ] ],
            [ 'C', [
                right_base_x+(bcorr+(thickness-bcorr))+depth/2,     (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth,
                right_base_x+(bcorr+(thickness-bcorr))+depth/8*6,   (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth/16*11,
                right_base_x+(bcorr+(thickness-bcorr))+depth/8*7,   (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth/16*7,
                right_base_x+(bcorr+(thickness-bcorr))+depth/10*11, (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2),
                right_base_x+(bcorr+(thickness-bcorr))+depth/2,     (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2),
                right_base_x+(bcorr+(thickness-bcorr)),             (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)
            ] ],
            [ 'L', [
                right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)
            ] ],
            # ear 7    
            [ 'L', right_points ],
            [ 'Z', [] ]
        ]

        # render slots for cramp ears
        # slot for left cramp ear1
        slot_l1 =  [ [ 'M', [
                bcorr,(depth+bcorr*2)+cramp_width,    bcorr+thickness,(depth+bcorr*2)+cramp_width,
                bcorr+thickness,(depth+bcorr*2)+cramp_width*2,    bcorr,(depth+bcorr*2)+cramp_width*2
                ] ],
                [ 'Z', [] ] 
        ]

        # slot for left cramp ear2
        slot_l2 =  [ [ 'M', [
                bcorr,(depth+bcorr*2)+cramp_width*3,    bcorr+thickness,(depth+bcorr*2)+cramp_width*3,
                bcorr+thickness,(depth+bcorr*2)+cramp_width*4,    bcorr,(depth+bcorr*2)+cramp_width*4
                ] ],
                [ 'Z', [] ] 
        ]

        # slot for right cramp ear1
        slot_r1 =  [ [ 'M', [
                right_base_x-bcorr,(depth+bcorr*2)+height-cramp_width,    right_base_x-(bcorr+thickness),(depth+bcorr*2)+height-cramp_width,
                right_base_x-(bcorr+thickness),(depth+bcorr*2)+height-cramp_width*2,    right_base_x-bcorr,(depth+bcorr*2)+height-cramp_width*2    
                ] ],
                [ 'Z', [] ] 
        ]

        # slot for right cramp ear2
        slot_r2 =  [ [ 'M', [
                right_base_x-bcorr,(depth+bcorr*2)+height-cramp_width*3,    right_base_x-(bcorr+thickness),(depth+bcorr*2)+height-cramp_width*3,
                right_base_x-(bcorr+thickness),(depth+bcorr*2)+height-cramp_width*4,    right_base_x-bcorr,(depth+bcorr*2)+height-cramp_width*4
                ] ],
                [ 'Z', [] ] 
        ]

        # vertical bends
        # left
        bend_line_vl1 = [ [ 'M', [ 0, 0, 
            0, depth ] ] ]
        bend_line_vl2 = [ [ 'M', [ 
            -((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2), 
            -((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2)+height ] ] ]
        bend_line_vl3 = [ [ 'M', [ 
            0, (depth+bcorr*2)+(height+bcorr*2), 
            0, (depth+bcorr*2)+(height+bcorr*2)+depth ] ] ]
        bend_line_vl4 = [ [ 'M', [ 
            (bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2), 
            (bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height ] ] ]
        bend_line_vl5 = [ [ 'M', [ 
            -(bcorr+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2), 
            -(bcorr+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth ] ] ]

            
        bend_line_vl6 = [ [ 'M', [ -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2), (depth+bcorr*2), 
            -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2), (depth+bcorr*2)+height ] ] ]
        bend_line_vl7 = [ [ 'M', [ -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr), (depth+bcorr*2), 
            -((thickness-bcorr)+slot_width+bcorr)-(depth+bcorr*2)-(bcorr+slot_width+thickness+bcorr), (depth+bcorr*2)+height ] ] ]
            
        # right
        bend_line_vr1 = [ [ 'M', [ 
            right_base_x, 0, 
            right_base_x, depth ] ] ]
        bend_line_vr2 = [ [ 'M', [ 
            right_base_x+((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2),
            right_base_x+((thickness-bcorr)+slot_width+bcorr),(depth+bcorr*2)+height ] ] ]
        bend_line_vr3 = [ [ 'M', [ 
            right_base_x, (depth+bcorr*2)+(height+bcorr*2), 
            right_base_x, (depth+bcorr*2)+(height+bcorr*2)+depth ] ] ]
        bend_line_vr4 = [ [ 'M', [ 
            right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2), 
            right_base_x-(bcorr+thickness+(thickness-bcorr)),(depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height ] ] ]
        bend_line_vr5 = [ [ 'M', [ 
            right_base_x+(bcorr+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2), 
            right_base_x+(bcorr+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+(height+thickness+bcorr*2)+depth ] ] ]
        

        bend_line_vr6 = [ [ 'M', [ 
            right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2), (depth+bcorr*2), 
            right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2), (depth+bcorr*2)+height ] ] ]
        bend_line_vr7 = [ [ 'M', [ 
            right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr), (depth+bcorr*2), 
            right_base_x+((thickness-bcorr)+slot_width+bcorr)+(depth+bcorr*2)+(bcorr+slot_width+thickness+bcorr), (depth+bcorr*2)+height ] ] ]
        
        # horizontal bends
        bend_line_h1 = [ [ 'M', [ 
            0,depth+bcorr, 
            right_base_x, depth+bcorr ] ] ]
        bend_line_h2 = [ [ 'M', [ 
            0,(depth+bcorr*2)+height+bcorr, 
            right_base_x, (depth+bcorr*2)+height+bcorr ] ] ]
        bend_line_h3 = [ [ 'M', [ 
            (bcorr+thickness+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+depth+bcorr, 
            right_base_x-(bcorr+thickness+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+depth+bcorr ] ] ]
        bend_line_h4 = [ [ 'M', [ 
            (bcorr+thickness+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height+thickness+bcorr, 
            right_base_x-(bcorr+thickness+(thickness-bcorr)), (depth+bcorr*2)+(height+bcorr*2)+(depth+bcorr*2)+height+thickness+bcorr ] ] ]


        # Embed drawing in group to make animation easier:
        # Translate group
        t = 'translate(' + str( self.view_center[0] ) + ',' + str( self.view_center[1] ) + ')'
        g_attribs = {inkex.addNS('label','inkscape'):'RobotBox', 'transform':t }
        g = inkex.etree.SubElement(self.current_layer, 'g', g_attribs)

        # Create SVG Path for box bounds
        style = { 'stroke': '#000000', 'fill': 'none' }
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bound_points )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        # Create SVG paths for crmap slots if set
        # render slots for cramp ears
        if cramp_height > 0:
            path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( slot_l1 )}
            inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )
            
            path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( slot_l2 )}
            inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )
            
            path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( slot_r1 )}
            inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )
            
            path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( slot_r2 )}
            inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        # Create SVG Paths for bend lines
        # draw bend lines with blue
        style = { 'stroke': '#44aaff', 'fill': 'none', 
            'stroke-dasharray': str(dash_width) + ',' + str(dash_step),
            # positive dash offset moves dash backward
            'stroke-dashoffset': str(dash_width) }

        # left
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl1 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl2 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl3 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl4 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl5 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )
        
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl6 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vl7 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        # right
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr1 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr2 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr3 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr4 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr5 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr6 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_vr7 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        # horizontal
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_h1 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_h2 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_h3 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_h4 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

if __name__ == '__main__':
    e = RobotBox()
    e.affect()


# vim: expandtab shiftwidth=4 tabstop=8 softtabstop=4 encoding=utf-8 textwidth=99
