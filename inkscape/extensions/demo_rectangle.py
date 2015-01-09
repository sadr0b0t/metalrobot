#! /usr/bin/env python
'''
Simple Inkscape plugin demo - draw rectangle with given width and height.
'''

import inkex
import simplestyle, sys

def points_to_svgd(p):
    f = p[0]
    p = p[1:]
    svgd = 'M%.3f,%.3f' % f
    for x in p:
        svgd += 'L%.3f,%.3f' % x
    svgd += 'z'
    return svgd

class Rectangle(inkex.Effect):
    def __init__(self):
        inkex.Effect.__init__(self)
        self.OptionParser.add_option("-w", "--width",
                        action="store", type="float",
                        dest="width", default=62.0,
                        help="Rectangle width")
        self.OptionParser.add_option("-H", "--height",
                        action="store", type="float",
                        dest="height", default=38.0,
                        help="Rectangle height")
        self.OptionParser.add_option("-u", "--unit",
                        action="store", type="string",
                        dest="unit", default="px",
                        help="The unit of dimensions")
    def effect(self):

        width  = inkex.unittouu( str(self.options.width) + self.options.unit )
        height = inkex.unittouu( str(self.options.height) + self.options.unit )

        # Debug messages
        #inkex.debug( "Width=" + str(width) + ", height=" + str(height) )

        # Generate rectangle points
        points = [ (0, 0), (width, 0), (width, height), (0, height) ]

        # Convert points to svg path
        path = points_to_svgd( points )

        # Embed rectangle in group to make animation easier:
        # Translate group, Rotate path.
        t = 'translate(' + str( self.view_center[0] ) + ',' + str( self.view_center[1] ) + ')'
        g_attribs = {inkex.addNS('label','inkscape'):'Demo rectangle', 'transform':t }
        g = inkex.etree.SubElement(self.current_layer, 'g', g_attribs)

        # Create SVG Path for demo rectangle
        style = { 'stroke': '#000000', 'fill': 'none' }
        rectangle_attribs = {'style':simplestyle.formatStyle(style), 'd':path}
        gear = inkex.etree.SubElement(g, inkex.addNS('path','svg'), rectangle_attribs )

if __name__ == '__main__':
    e = Rectangle()
    e.affect()


# vim: expandtab shiftwidth=4 tabstop=8 softtabstop=4 encoding=utf-8 textwidth=99
