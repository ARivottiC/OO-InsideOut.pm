# NAME

OO::InsideOut - Minimal support for Inside-Out Classes

# VERSION

0.04

# SYNOPSIS

    package My::Name;

    use OO::InsideOut qw(id register);

    register \my( %Name, %Surname );

    sub new {
        my $class = shift;

        return bless \(my $o), ref $class || $class;
    }

    sub name { 
        my $id = id( shift );

        scalar @\_
            and $Name{ $id } = shift;

        return $Name{ $id };
    }

    sub surname { 
        my $id = id( shift );

        scalar @\_
            and $Surname{ $id } = shift;

        return $Surname{ $id };
    }

    ...



# EXPORT

Nothing by default but every function, in [FUNCTIONS](http://search.cpan.org/perldoc?FUNCTIONS), can be exported on demand.

# DESCRIPTION

__NOTE: If you're developing for perl 5.10 or later, please consider 
using [Hash::Util::FieldHash](http://search.cpan.org/perldoc?Hash::Util::FieldHash) instead.__

OO::InsideOut provides minimal support for Inside-Out Classes for perl 5.8 
or later. By minimal, understand;

- No special methods or attributtes;
- Don't use source filters or any kind of metalanguage;
- No need for a special constructor;
- No need to register objects;
- No serialization hooks (like Storable, Dumper, etc);



It provides:

- Automatic object registration;
- Automatic object destruction;
- Thread support (but not shared);
- Foreign inheritance;
- mod\_perl compatibility 



# FUNCTIONS

## id

    id( $object );

Uses [Scalar::Util::refaddr](http://search.cpan.org/perldoc?Scalar::Util#refaddr) to return the reference 
address of $object.

## register

    register( @hashrefs );

Register the given hashrefs for proper cleanup.

Returns an HASH ref with registered objects in the CLASS. See [CAVEATS](http://search.cpan.org/perldoc?CAVEATS).

## Dumper

    Dumper( $object );

If available, uses [Data::Dumper::Dumper](http://search.cpan.org/perldoc?Data::Dumper#Dumper) to dump the
object's data.

__WARNING: May be removed in the future!!!__

# HOW IT WORKS

When registering hashes, and only then, __OO::InsideOut__ will:

- Wrap any new() method\_\_\*\_\_, in the inheritance tree, with the ability to register objects;
- Wrap any DESTROY() method\_\_\*\_\_, in the inheritance tree, with the ablity to cleanup the object's data;
- If no DESTROY() method was found, it provides one in the firs package of the inheritance tree;



__\* This is done only once per package__.

# PERFORMANCE

Every Inside-Out technique, using an __id__ to identify the __object__, will be 
slower than the classic OO approach: it's just the way it is.

Consider:

    sub name {
        my $self = shift;

        scalar @\_
            && $Name{ id( $self ) } = shift;

        return $Name{ id( $self ) );
    }



In this example, the code is calling the __id__ twice, causing uncessary 
overload. If you are going to use __id__ more than once, in the same scope, 
consider saving it in an variable earlier: 

    sub name { 
        my $id = id( shift );

        scalar @\_
            && $Name{ $id } = shift;

        return $Name{ $id };
    }



# MIGRATING TO [Hash::Util::FieldHash](http://search.cpan.org/perldoc?Hash::Util::FieldHash)

Bare in mind that, besides the obvious diferences between the two modules, 
in [Hash::Util::FieldHash](http://search.cpan.org/perldoc?Hash::Util::FieldHash), the cleanup process is triggered before 
calling DESTROY(). In OO::Insideout, this only happens after any 
DESTROY() defined in the package.

See [How to use Field Hashes](http://search.cpan.org/perldoc?Hash::Util::FieldHas#How to use Field Hashes).

# DIAGNOSTICS

- must provide, at least, one hash ref! 

Besides the obvious reason, this migth happen while using `my` with a list with only one item:

    register \my( %Field ) #WRONG
    register \my %Field    #RIGTH



# CAVEATS

register(), on request, will return an HASH ref with all the objects 
registered in the CLASS. 

If, for any reason, you need to copy/grep this HASH ref, make sure to 
[weaken](http://search.cpan.org/perldoc?Scalar::Util#weaken) every entry again. See 
[Scalar::Util::weaken](http://search.cpan.org/perldoc?Scalar::Util#weaken) for more detail on this subject.

# There's more than one way to do it (TMTOWTDI)

Of course, there are other ways to use this module. Here's how I do it:

    package My::Name;

    # don't import nothing, I like my namespace clean
    use OO::InsideOut ();

    OO::InsideOut::register \my( %Id, %Name, %Surname );

    # save a reference for id function
    my $id = \&OO::InsideOut::id;

    sub new {
        my $class = shift;

        my $self = bless \(my $o), ref $class || $class;

        $Id{ $self->$id } = rand;

        return $self;
    }

    sub name { 
        my $id = shift->$id;

        scalar @\_
            and $Name{ $id } = shift;

        return $Name{ $id };
    }

    sub surname { 
        my $id = shift->$id;

        scalar @\_
            and $Surname{ $id } = shift;

        return $Surname{ $id };
    }

    # look, I can have an id method, no colision here
    sub id { return $Id{ shift->$id } }

# AUTHOR

André "Rivotti" Casimiro, `<rivotti at cpan.org>`

# BUGS

Please report any bugs or feature requests through the issue tracker
at [https://github.com/ARivottiC/OO-InsideOut/issues](https://github.com/ARivottiC/OO-InsideOut/issues).

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc OO::InsideOut



You can also look for information at:

- GitHub 

[https://github.com/ARivottiC/OO-InsideOut](https://github.com/ARivottiC/OO-InsideOut)

- AnnoCPAN: Annotated CPAN documentation

[http://annocpan.org/dist/OO-InsideOut](http://annocpan.org/dist/OO-InsideOut)

- CPAN Ratings

[http://cpanratings.perl.org/d/OO-InsideOut](http://cpanratings.perl.org/d/OO-InsideOut)

- Search CPAN

[http://search.cpan.org/dist/OO-InsideOut/](http://search.cpan.org/dist/OO-InsideOut/)



# ACKNOWLEDGEMENTS



# SEE ALSO

[Alter](http://search.cpan.org/perldoc?Alter), [Class::InsideOut](http://search.cpan.org/perldoc?Class::InsideOut), [Class::Std](http://search.cpan.org/perldoc?Class::Std), [Hash::Util::FieldHash](http://search.cpan.org/perldoc?Hash::Util::FieldHash), 
[Object::InsideOut](http://search.cpan.org/perldoc?Object::InsideOut).

# LICENSE AND COPYRIGHT

Copyright 2013 André Rivotti Casimiro.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.