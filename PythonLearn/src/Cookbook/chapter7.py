'''
Functions

Created on Apr 11, 2016

@author: fzhang
'''

'''
# 7.1 Writing Functions That Accept Any Number of Arguments
# sulution:To write a function that accepts any number of positional arguments,
# use a * argument.
'''


def avg(first, *rest):
    return(first + sum(rest)) / (1 + len(rest))


# To accept any number of keyword arguments, use an argument
def make_element(name, value, **attrs):
    import html
    keyvals = ['%s ="%s"' % item for item in attrs.items()]
    attr_str = ''.join(keyvals)
    element = '<{name}{attrs}>{value}</{name}>'.format(
        name=name,
        attrs=attr_str,
        value=html.escape(value))
    return element

'''
# 7.2 Writing Functions That Accept Any number of Arguments
solution:This feature is easy to implement if you place the keyword arguments
after a * argument or a single unnamed *.
'''


def recv(maxsize, *, block):
    'Receives a message'
    pass


def mininum(*values, clip=None):
    m = min(values)
    if clip is not None:
        m = clip if clip > m else m
    return m

'''
# 7.3 Attaching informational Metadata to Function Arguments
Function argument annotations can be a useful way to
give programmers hints about how a function is supposed to be used.

The Python interpreter does not attach any semantic meaning to
the attached annotations. They are not type checks,
nor do they make Python behave any differently than
it did before. However, they might give useful hints to
others reading the source code about what you had in mind.
'''


def add(x: int, y: int) -> int:
    return x+y


'''
7.4. Returning Multiple Values from a Function
solution:To return multiple values from a function, simply return a tuple.
'''


def myfun():
    return 1, 2, 3


'''
7.5. Defining Functions with Default Arguments
solution:On the surface, defining a function with optional arguments
is easy¡ªsimply assign values in the definition and make sure that
default arguments appear last.
'''


def spam(a, b=42):
    print(a, b)
