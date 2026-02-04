	# Probably a lot of the following is cargo cult.
	# My XS-fu is not strong.
	#
	
	$dynamic_config{LIBS}   = [''];
	$dynamic_config{DEFINE} = '';
	$dynamic_config{INC}    = '-I.';
	
	if (eval {require ExtUtils::Constant; 1}) {
		my @names = (qw());
		ExtUtils::Constant::WriteConstants(
			NAME         => do { my $name = $meta->{name}; $name =~ s/-/::/g; $name },
			NAMES        => \@names,
			DEFAULT_TYPE => 'IV',
			C_FILE       => 'const-c.inc',
			XS_FILE      => 'const-xs.inc',
		);
	}
	else {
		use File::Copy;
		use File::Spec;
		for my $file ('const-c.inc', 'const-xs.inc') {
			my $fallback = File::Spec->catfile('fallback', $file);
			copy($fallback, $file) or die "Can't copy $fallback to $file: $!";
		}
	}

	my $STRICT;
	$STRICT++ if ( $ENV{GITHUB_REPOSITORY} and $ENV{GITHUB_REPOSITORY} =~ /p5-sub-handlesvia/ );
	$STRICT++ if ( $ENV{EXTENDED_TESTING}  and $ENV{USER} and $ENV{USER} eq 'tai' );
	$STRICT++ if ( $ENV{PERL_XS_STRICTC89} );
	if ( $STRICT ) {
		require Config;
		my $SPACE = q{ };
		$dynamic_config{CCFLAGS} = join $SPACE => (
			$Config::Config{ccflags},
			'-std=c89',
			'-Werror',
		);
	}
