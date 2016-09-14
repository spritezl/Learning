'''
Created on Feb 14, 2016

@author: fzhang
'''


import sys
x = 1234
res = 'integers:...%d...%-6d...%06d' % (x, x, x)
print(res)

x = 1.23456789
res = '%e | %f |%g' % (x, x, x)
print(res)

res = '%-6.2f | %05.2f | %+06.1f' % (x, x, x)
print(res)

'''
When sizes are not known until runtime, you can use a computed width and
precision by specifying them with a * in the format string to force
their values to be taken from the next item in the inputs to
the right of the % operator--the 4 in the tuple here gives precision:
'''
res = '%f, %.2f, %.*f' % (1 / 3.0, 1 / 3.0, 4, 1 / 3.0)
print(res)


# Dictionary-Based Formatting Expressions
res = '%(qty)d more %(food)s' % {'qty': 1, 'food': 'spam'}
print(res)

# working with vars() built-in function
food = 'spam'
qty = 10
# print(vars())
res = '%(qty)d more %(food)s' % vars()
print(res)


# Formatting Method Basics
template = '{0}, {1} and {2}'
print(template.format('spam', 'ham', 'eggs'))

template = '{motto}, {pork} and {food}'
print(template.format(motto='spam', pork='ham', food='eggs'))

template = '{}, {} and {}'
print(template.format('spam', 'ham', 'eggs'))

# Adding Keys, Attributes, and Offsets
res = 'My {1[kind]} runs {0.platform}'.format(sys, {'kind': 'laptop'})
print(res)

res = 'My {map[kind]} runs {sys.platform}'.format(sys=sys,
                                                  map={'kind': 'laptop'})
print(res)

somelist = list('spam')
res = 'first={0[0]}, third={0[2]}'.format(somelist)
print(res)

res = 'first={0}, last={1}'.format(somelist[0], somelist[-1])
print(res)

parts = somelist[0], somelist[-1], somelist[1:3]
res = 'first={0}, last={1}, middle={2}'.format(*parts)
print(res)
