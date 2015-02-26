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
        ear1 = height / 3

        # big ears skew = ~25 degrees
        # skew_shift = depth*2/3 * tg(25)
        skew_shift = depth*2/3 * 0.47

        # inner width of the box (without left and right slots),
        # use it just for convenience
        width2 = width-thickness*4

        # Generate box points
        # Details on the shape here:
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft1.svg
        # https://github.com/1i7/metalrobot/blob/master/inkscape/extensions/robotbox-devel/draft2.svg
        bound_points = [
            [ 'M', [
                # start from left bottom "ear" and go left and up
                # ear 1
                0,0,    -ear1,0, 
                -ear1,depth-thickness*2,    0,depth-thickness*2, 
                # ear 2
                0,depth,    -thickness*2,depth,    -thickness*2-depth,depth,    -thickness*2-depth-thickness*4,depth,    
                -thickness*2-depth-thickness*4-depth+thickness,depth,
                
                -thickness*2-depth-thickness*4-depth+thickness,depth+height-thickness*2,    -thickness*2-depth-thickness*4,depth+height-thickness*2,    
                -thickness*2-depth,depth+height-thickness*2,    -thickness*2,depth+height-thickness*2,    0,depth+height-thickness*2,
                # ear 3
                0,depth+height,    -ear1,depth+height,
                -ear1,depth+height+depth-thickness*2,    thickness*2,depth+height+depth-thickness*2,
                # ear 4
                thickness*2,depth+height+depth,    thickness*2-depth*2/3,depth+height+depth+skew_shift,
                thickness*2-depth*2/3,depth+height+depth+height-thickness*2-skew_shift,    thickness*2,depth+height+depth+height-thickness*2
            ] ],
            # ear 5: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            # m 0,0 c -39.88719,-0.7697 -90.44391,-0.7593 -73.26685,35.3985 11.37507,22.1855 33.21015,45.182 73.26685,46.0975 z
            [ 'L', [
                thickness*2,depth+height+depth+height+thickness,    -thickness,depth+height+depth+height+thickness
            ] ],
            [ 'C', [
#                -39.88719,          depth+height+depth+height+thickness-0.7697,
#                -90.44391,          depth+height+depth+height+thickness-0.7593,
#                -73.26685,          depth+height+depth+height+thickness+35.3985,
#                -73.26685+11.37507, depth+height+depth+height+thickness+35.3985+22.1855,
#                -73.26685+33.21015, depth+height+depth+height+thickness+35.3985+45.182,

                -thickness-(depth-thickness*2)/2,     depth+height+depth+height+thickness,
                -thickness-(depth-thickness*2)/10*11, depth+height+depth+height+thickness,
                -thickness-(depth-thickness*2)/8*7,   depth+height+depth+height+thickness+(depth-thickness*2)/16*7,
                -thickness-(depth-thickness*2)/8*6,   depth+height+depth+height+thickness+(depth-thickness*2)/16*11,
                -thickness-(depth-thickness*2)/2,     depth+height+depth+height+thickness+(depth-thickness*2),
                -thickness,                           depth+height+depth+height+thickness+(depth-thickness*2)
            ] ],
            # now go to the right and go down in reverse order
            # ear 6: manual shape (drawn for 62x38x23 box), converted to proportion based on depth value
            [ 'L', [
                width2+thickness,depth+height+depth+height+thickness+(depth-thickness*2)
            ] ],
            [ 'C', [
                width2+thickness+(depth-thickness*2)/2,     depth+height+depth+height+thickness+(depth-thickness*2),
                width2+thickness+(depth-thickness*2)/8*6,   depth+height+depth+height+thickness+(depth-thickness*2)/16*11,
                width2+thickness+(depth-thickness*2)/8*7,   depth+height+depth+height+thickness+(depth-thickness*2)/16*7,
                width2+thickness+(depth-thickness*2)/10*11, depth+height+depth+height+thickness,
                width2+thickness+(depth-thickness*2)/2,     depth+height+depth+height+thickness,
                width2+thickness,                           depth+height+depth+height+thickness
            ] ],
            [ 'L', [
                width2-thickness*2,depth+height+depth+height+thickness
            ] ],
            # ear 7    
            [ 'L', [
                width2-thickness*2,depth+height+depth+height-thickness*2,    width2-thickness*2+depth*2/3,depth+height+depth+height-thickness*2-skew_shift,
                width2-thickness*2+depth*2/3,depth+height+depth+skew_shift,    width2-thickness*2,depth+height+depth,
                # ear 8
                width2-thickness*2,depth+height+depth-thickness*2,    width2+ear1,depth+height+depth-thickness*2,
                width2+ear1,depth+height,    width2,depth+height,
                # ear 9
                width2,depth+height-thickness*2,    width2+thickness*2,depth+height-thickness*2,    width2+thickness*2+depth,depth+height-thickness*2,    
                width2+thickness*2+depth+thickness*4,depth+height-thickness*2,    width2+thickness*2+depth+thickness*4+depth-thickness,depth+height-thickness*2,

                width2+thickness*2+depth+thickness*4+depth-thickness,depth,    width2+thickness*2+depth+thickness*4,depth,    width2+thickness*2+depth,depth,    
                width2+thickness*2,depth,    width2,depth,
                # ear 10
                width2,depth-thickness*2,    width2+ear1,depth-thickness*2,
                width2+ear1,0,    width2,0
            ] ],
            [ 'Z', [] ]
        ]

        # vertical bends
        # left
        bend_line_vl1 = [ [ 'M', [ 0, 0, 
            0, depth-thickness*2 ] ] ]
        bend_line_vl2 = [ [ 'M', [ -thickness*2, depth, 
            -thickness*2, depth+height-thickness*2 ] ] ]
        bend_line_vl3 = [ [ 'M', [ 0, depth+height, 
            0, depth+height+depth-thickness*2 ] ] ]
        bend_line_vl4 = [ [ 'M', [ thickness*2, depth+height+depth, 
            thickness*2, depth+height+depth+height-thickness*2 ] ] ]
        bend_line_vl5 = [ [ 'M', [ -thickness, depth+height+depth+height+thickness, 
            -thickness, depth+height+depth+height+thickness+depth-thickness*2 ] ] ]

            
        bend_line_vl6 = [ [ 'M', [ -thickness*2-depth, depth, 
            -thickness*2-depth, depth+height-thickness*2 ] ] ]
        bend_line_vl7 = [ [ 'M', [ -thickness*2-depth-thickness*4, depth, 
            -thickness*2-depth-thickness*4, depth+height-thickness*2 ] ] ]
            
        # right
        bend_line_vr1 = [ [ 'M', [ width2, 0, 
            width2, depth-thickness*2 ] ] ]
        bend_line_vr2 = [ [ 'M', [ width2+thickness*2, depth, 
            width2+thickness*2, depth+height-thickness*2 ] ] ]
        bend_line_vr3 = [ [ 'M', [ width2, depth+height, 
            width2, depth+height+depth-thickness*2 ] ] ]
        bend_line_vr4 = [ [ 'M', [ width2-thickness*2, depth+height+depth, 
            width2-thickness*2, depth+height+depth+height-thickness*2 ] ] ]
        bend_line_vr5 = [ [ 'M', [ width2+thickness, depth+height+depth+height+thickness, 
            width2+thickness, depth+height+depth+height+thickness+depth-thickness*2 ] ] ]
        

        bend_line_vr6 = [ [ 'M', [ width2+thickness*2+depth, depth, 
            width2+thickness*2+depth, depth+height-thickness*2 ] ] ]
        bend_line_vr7 = [ [ 'M', [ width2+thickness*2+depth+thickness*4, depth, 
            width2+thickness*2+depth+thickness*4, depth+height-thickness*2 ] ] ]
        
        # horizontal bends
        bend_line_h1 = [ [ 'M', [ 0, depth-thickness, 
            width2, depth-thickness ] ] ]
        bend_line_h2 = [ [ 'M', [ 0, depth+height-thickness, 
            width2, depth+height-thickness ] ] ]
        bend_line_h3 = [ [ 'M', [ thickness*2, depth+height+depth-thickness, 
            width2-thickness*2, depth+height+depth-thickness ] ] ]
        bend_line_h4 = [ [ 'M', [ thickness*2, depth+height+depth+height, 
            width2-thickness*2, depth+height+depth+height ] ] ]


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
