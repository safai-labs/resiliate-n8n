#!/usr/bin/perl

%includes = {};

sub resolver {
	local ($depth, $filename) = (@_);
	local *FH;
	if (length($filename) == 0)  {
		*FH=*STDIN
	} else {
		 open(FH, '<', $filename);
	}
	die "This is too deep" if ( $depth > 20 );
	while(<FH>) {
		if (/^\s*##include\s+([^\s]+)/) {
				# if ($includes[$1]) {
				# 	print STDERR "Already include $filename, skipping!";
				# 	next;
				# }
				# $include[$1] = 1;
				resolver(++$depth, $1);
		}
		else { 
			print;
		}
	}
}


if($#ARGV < 0) {
	resolver(0)
}
else { 
	foreach $f (@ARGV) {
		resolver(0, $f);
	}
}
