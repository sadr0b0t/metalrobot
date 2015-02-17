#! /usr/bin/env python
'''
Draw box with given width, height and depth.
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
                        dest="thickness", default=0.01,
                        help="Paper Thickness - sometimes that is important")
        self.OptionParser.add_option("-u", "--unit",
                        action="store", type="string",
                        dest="unit", default="px",
                        help="The unit of dimensions")
                        
    def effect(self):

        width  = self.unittouu( str(self.options.width) + self.options.unit )
        height = self.unittouu( str(self.options.height) + self.options.unit )
        depth  = self.unittouu( str(self.options.depth) + self.options.unit )
        thickness  = self.unittouu( str(self.options.thickness) + self.options.unit )

        # small ears (to be hidden inside the box borders) length
        ear1 = depth * 2 / 3

        # big ears skew = ~25 degrees
        # skew_shift = depth*2/3 * tg(25)
        skew_shift = depth*2/3 * 0.47

        # Generate box points
        # Details on the shape here:
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft1.svg
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft2.svg
        bound_points = [
            [ 'M', [
                # start from left bottom "ear" and go left and up
                # ear 1
                0, 0,    -ear1, 0, 
                -ear1, depth,    0, depth, 
                # ear 2
                0, depth+thickness,    -depth, depth+thickness,    -depth-thickness*3, depth+thickness,    -depth-thickness*3-depth, depth+thickness,
                -depth-thickness*3-depth, depth+thickness+height,    -depth-thickness*3, depth+thickness+height,    -depth, depth+thickness+height,    0, depth+thickness+height,
                # ear 3
                0, depth+thickness+height+thickness,    -ear1, depth+thickness+height+thickness, 
                -ear1, depth+thickness+height+thickness+depth,    thickness, depth+thickness+height+thickness+depth,
                # ear 4
                thickness, depth+thickness+height+thickness+depth+thickness,    thickness-depth*2/3, depth+thickness+height+thickness+depth+thickness+skew_shift,
                thickness-depth*2/3, depth+thickness+height+thickness+depth+thickness+height-skew_shift,    thickness, depth+thickness+height+thickness+depth+thickness+height
            ] ],
            # ear 5: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            # m 0,0 c -39.88719,-0.7697 -90.44391,-0.7593 -73.26685,35.3985 11.37507,22.1855 33.21015,45.182 73.26685,46.0975 z
            [ 'L', [
                thickness, depth+thickness+height+thickness+depth+thickness+height+thickness, 0, depth+thickness+height+thickness+depth+thickness+height+thickness
            ] ],
            [ 'C', [
#                -39.88719, depth+thickness+height+thickness+depth+thickness+height+thickness-0.7697,
#                -90.44391, depth+thickness+height+thickness+depth+thickness+height+thickness-0.7593,
#                -73.26685, depth+thickness+height+thickness+depth+thickness+height+thickness+35.3985,
#                -73.26685+11.37507, depth+thickness+height+thickness+depth+thickness+height+thickness+35.3985+22.1855,
#                -73.26685+33.21015, depth+thickness+height+thickness+depth+thickness+height+thickness+35.3985+45.182,

                -depth/2, depth+thickness+height+thickness+depth+thickness+height+thickness,
                -depth/10*11, depth+thickness+height+thickness+depth+thickness+height+thickness,
                -depth/8*7, depth+thickness+height+thickness+depth+thickness+height+thickness+depth/16*7,
                -depth/8*6, depth+thickness+height+thickness+depth+thickness+height+thickness+depth/16*11,
                -depth/2, depth+thickness+height+thickness+depth+thickness+height+thickness+depth,
                0, depth+thickness+height+thickness+depth+thickness+height+thickness+depth

            ] ],
            # now go to the right and go down in reverse order
            # ear 6: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            # m 0,0 c 17.177,-36.1578 -33.3797,-36.1682 -73.2847,-35.3867 l 0,81.4958 c 40.0746,-0.9273 61.9096,-23.9238 73.2847,-46.1093 z
            [ 'L', [
                width, depth+thickness+height+thickness+depth+thickness+height+thickness+depth
            ] ],
            [ 'C', [
#                width+40.0746, depth+thickness+height+thickness+depth+thickness+height+thickness+depth-0.9273,
#                width+61.9096, depth+thickness+height+thickness+depth+thickness+height+thickness+depth-23.9238,
#                width+73.2847, depth+thickness+height+thickness+depth+thickness+height+thickness+depth-46.1093,
#                width+73.2847+17.177, depth+thickness+height+thickness+depth+thickness+height+thickness+depth-46.1093-36.1578,
#                width+73.2847-33.3797, depth+thickness+height+thickness+depth+thickness+height+thickness+depth-46.1093-36.1682,

                width+depth/2, depth+thickness+height+thickness+depth+thickness+height+thickness+depth,
                width+depth/8*6, depth+thickness+height+thickness+depth+thickness+height+thickness+depth/16*11,
                width+depth/8*7, depth+thickness+height+thickness+depth+thickness+height+thickness+depth/16*7,
                width+depth/10*11, depth+thickness+height+thickness+depth+thickness+height+thickness,
                width+depth/2, depth+thickness+height+thickness+depth+thickness+height+thickness,
                width, depth+thickness+height+thickness+depth+thickness+height+thickness
            ] ],
            [ 'L', [
                width-thickness, depth+thickness+height+thickness+depth+thickness+height+thickness
            ] ],
            # ear 7    
            [ 'L', [
                width-thickness, depth+thickness+height+thickness+depth+thickness+height,    width-thickness+depth*2/3, depth+thickness+height+thickness+depth+thickness+height-skew_shift,
                width-thickness+depth*2/3, depth+thickness+height+thickness+depth+thickness+skew_shift,    width-thickness, depth+thickness+height+thickness+depth+thickness,
                # ear 8
                width-thickness, depth+thickness+height+thickness+depth,    width+ear1, depth+thickness+height+thickness+depth,
                width+ear1, depth+thickness+height+thickness,    width, depth+thickness+height+thickness,
                # ear 9
                width, depth+thickness+height,    width+depth, depth+thickness+height,    width+depth+thickness*3, depth+thickness+height,    width+depth+thickness*3+depth, depth+thickness+height,
                width+depth+thickness*3+depth, depth+thickness,    width+depth+thickness*3, depth+thickness,    width+depth, depth+thickness,    width, depth+thickness,
                # ear 10
                width, depth,    width+ear1, depth,
                width+ear1, 0,    width, 0
            ] ],
            [ 'Z', [] ]
        ]

        # vertical bends
        bend_line_v11 = [ [ 'M', [ 0, 0, 
            0, depth+thickness+height+thickness+depth ] ] ]
        bend_line_v12 = [ [ 'M', [ thickness, depth+thickness+height+thickness+depth+thickness, 
            thickness, depth+thickness+height+thickness+depth+thickness+height ] ] ]
        bend_line_v13 = [ [ 'M', [ 0, depth+thickness+height+thickness+depth+thickness+height+thickness, 
            0, depth+thickness+height+thickness+depth+thickness+height+thickness+depth ] ] ]
        
        bend_line_v21 = [ [ 'M', [ width, 0, 
            width, depth+thickness+height+thickness+depth ] ] ]
        bend_line_v22 = [ [ 'M', [ width-thickness, depth+thickness+height+thickness+depth+thickness, 
            width-thickness, depth+thickness+height+thickness+depth+thickness+height ] ] ]
        bend_line_v23 = [ [ 'M', [ width, depth+thickness+height+thickness+depth+thickness+height+thickness, 
            width, depth+thickness+height+thickness+depth+thickness+height+thickness+depth ] ] ]
        
        
        bend_line_v14 = [ [ 'M', [ -depth-thickness/2, depth+thickness, 
            -depth-thickness/2, depth+thickness+height ] ] ]
        bend_line_v15 = [ [ 'M', [ -depth-thickness*3-thickness/2, depth+thickness, 
            -depth-thickness*3-thickness/2, depth+thickness+height ] ] ]

        bend_line_v24 = [ [ 'M', [ width+depth+thickness/2, depth+thickness, 
            width+depth+thickness/2, depth+thickness+height ] ] ]
        bend_line_v25 = [ [ 'M', [ width+depth+thickness*3+thickness/2, depth+thickness, 
            width+depth+thickness*3+thickness/2, depth+thickness+height ] ] ]
        
        # horizontal bends
        bend_line_h1 = [ [ 'M', [ 0, depth+thickness/2, 
            width, depth+thickness/2 ] ] ]
        bend_line_h2 = [ [ 'M', [ 0, depth+thickness+height+thickness/2, 
            width, depth+thickness+height+thickness/2 ] ] ]
        bend_line_h3 = [ [ 'M', [ thickness, depth+thickness+height+thickness+depth+thickness/2, 
            width-thickness, depth+thickness+height+thickness+depth+thickness/2 ] ] ]
        bend_line_h4 = [ [ 'M', [ thickness, depth+thickness+height+thickness+depth+thickness+height+thickness/2, 
            width-thickness, depth+thickness+height+thickness+depth+thickness+height+thickness/2 ] ] ]


        # Embed drawing in group to make animation easier:
        # Translate group
        t = 'translate(' + str( self.view_center[0] ) + ',' + str( self.view_center[1] ) + ')'
        g_attribs = {inkex.addNS('label','inkscape'):'RobotBox', 'transform':t }
        g = inkex.etree.SubElement(self.current_layer, 'g', g_attribs)

        # Create SVG Path for box bounds
        style = { 'stroke': '#000000', 'fill': 'none' }
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bound_points )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        # Create SVG Paths for bend lines
        # draw bend lines with blue
        style = { 'stroke': '#44aaff', 'fill': 'none' }
        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v11 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v12 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v13 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v21 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v22 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v23 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )
        

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v14 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v15 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v24 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

        path_attribs = {'style':simplestyle.formatStyle(style), 'd':formatPath( bend_line_v25 )}
        inkex.etree.SubElement(g, inkex.addNS('path','svg'), path_attribs )

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
