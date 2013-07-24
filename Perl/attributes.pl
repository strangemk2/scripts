use 5.016;
use Attribute::Handlers;

sub UNIVERSAL::loud : ATTR(CODE) {
    my ( $pkg, $sym, $code ) = @_;
    no warnings 'redefine';
    *{$sym} = sub {
        return uc $code->(@_);
    };
}

sub foo : loud {
    return "this is $_[0]";
}

say foo("a spoon");
say foo("a fork");
