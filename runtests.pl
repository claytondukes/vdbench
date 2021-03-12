#!/usr/bin/env perl
#
# sudo apt -y install cpanminus
# cpanm Config::IniFiles InfluxDB::Client::Simple
# for Influx, make sure the db you are inserting data into already exists:
# curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE vdbench"
# (replace 'localhost' above for remote influxdb servers)
# Maybe I'll create if not exists in another script version...
#
use strict;
use warnings;
use Getopt::Std;
use Data::Dumper;
use InfluxDB::Client::Simple;
use Config::IniFiles;
use Date::Parse;
use Sys::Hostname;
use POSIX qw(strftime);

$|= 1; # disable output buffering.

my $progname = $0;
$progname =~ s{.*/}{}; # leave just program name without path
sub help {
  print STDERR <<END;
USAGE: $progname -i <ini file> -f <flatfile from vdbench output>
Options:
USAGE: $progname -i <ini file> -f <flatfile from vdbench output>
Options:
    -i          location of ini settings
    -f          location of flatfile.html
    -w          workload file (override specified workload in $progname.ini)
eg,
    $progname -i runtests.ini -f results/flatfile.html
END
  exit 1;
}

############################
#  Process command line args
############################
#help() if (($#ARGV+1)==0);
help() if defined $ARGV[0] and $ARGV[0] eq "-h";
getopts('i:f:w:') or help();
my $ini  = defined $main::opt_i ? $main::opt_i : "runtests.ini";
my $cfg = Config::IniFiles->new( -file => "$ini" );
my $flatfile = defined $main::opt_f ? $main::opt_f : $cfg->val('vdbench','outdir') . "/flatfile.html";
my $workload = defined $main::opt_w ? $main::opt_w : $cfg->val('vdbench','workload');
my ($hostname) = split /\./, hostname(); # Split by '.', keep the first part

my $time = time;


# Run vdbench
my $cmd = $cfg->val('vdbench','exe')
. " -f " . $workload
. " -o " . $cfg->val('vdbench','outdir')
. " -e " . $cfg->val('vdbench','elapse_time');

$cmd = $cmd . " lun=" . $cfg->val('vdbench','lun') if $cfg->val('vdbench','lun');

my $cycle=0;
printf "Logging script output to %s\n", $cfg->val('vdbench','log');
while ($cycle < $cfg->val('vdbench','cycles')) {
  print "Running $cmd...\n";
  printf "Cycle $cycle of %s\n", $cfg->val('vdbench','cycles');
  spinner($cfg->val('vdbench','elapse_time'));
  my $output = `$cmd`;
  if ($cfg->val('vdbench','log') eq "stdout") {
    print "$output\n"
  } else {
    open(LOG, '>>', $cfg->val('vdbench','log')) or die $!;
    print LOG "$output\n";
    close(LOG);
  }

  if ($cfg->val("general","debug") gt 0) {
    if ($cfg->val("general","output") eq "influx" ) {
      print "Using Influx Output\n";
      printf "host=%s\n", $cfg->val('influxdb','host');
      printf "port=%s\n", $cfg->val('influxdb','port');
      printf "protocol=%s\n", $cfg->val('influxdb','protocol');
      printf "db=%s\n", $cfg->val('influxdb','db');
      printf "table=%s\n", $cfg->val('influxdb','table');
    }
  }

# InfluxDB not implemented yet
  if ($cfg->val("general","output") eq "influx" ) {
    my $client = InfluxDB::Client::Simple->new( 
      host => $cfg->val("influxdb","host"), 
      port => $cfg->val("influxdb","port"),
      protocol => $cfg->val("influxdb","proto") 
    ) or die "Can't instantiate influxdb client";
    # Check server connectivity
    my $result = $client->ping();
    die "No pong" unless $result;
  }

  if ($cfg->val("general","output") eq "graphite" ) {
    my $regex = qr/^\d+:\d+:\d+\.\d{3}\s+(\S+)-(\d+\S+)-\w+\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/;

    printf "host=%s port=%s, proto=%s\n",
    $cfg->val('graphite','host'),
    $cfg->val("graphite","port"),
    $cfg->val("graphite","proto") 
    if $cfg->val("general","debug") gt 0;

    my $sock = IO::Socket::INET->new(
      PeerAddr => $cfg->val("graphite","host"),
      PeerPort => $cfg->val("graphite","port"),
      Proto    => $cfg->val("graphite","proto"),
    );
    die "Unable to connect to graphite server: $!\n" unless ($sock->connected);

    my (%rows);
    my $time = time;

    open my $fh, '<', $flatfile or die "Could not open '$flatfile' $!";
    while (my $line = <$fh>) {
      chomp $line;
      print $line if $cfg->val("general","debug") gt 1;
      if ($line =~ /$regex/) {
        $rows{tod}          = $1;
        $rows{timestamp}    = $2;
        $rows{run}          = $3;
        $rows{interval}     = $4;
        $rows{reqrate}      = $5;
        $rows{rate}         = $6;
        $rows{MBps}         = $7;
        $rows{iobytes}      = $8;
        $rows{readpct}      = $9;
        $rows{resp}         = $10;
        $rows{read_resp}    = $11;
        $rows{write_resp}   = $12;
        $rows{resp_max}     = $13;
        $rows{read_max}     = $14;
        $rows{write_max}    = $15;
        $rows{resp_std}     = $16;
        $rows{read_std}     = $17;
        $rows{write_std}    = $18;
        $rows{xfersize}     = $19;
        $rows{threads}      = $20;
        $rows{rdpct}        = $21;
        $rows{rhpct}        = $22;
        $rows{whpct}        = $23;
        $rows{seekpct}      = $24;
        $rows{lunsize}      = $25;
        $rows{version}      = $26;
        $rows{compratio}    = $27;
        $rows{dedupratio}   = $28;
        $rows{queue_depth}  = $29;
        $rows{cpu_used}     = $30;
        $rows{cpu_user}     = $31;
        $rows{cpu_kernel}   = $32;
        $rows{cpu_wait}     = $33;
        $rows{cpu_idle}     = $34;
        $time = str2time($rows{timestamp});
        print Dumper(\%rows) if $cfg->val("general","debug") gt 1;
        foreach my $key (keys %rows) {
          my $value = $rows{$key};
          next if $key =~ /timestamp|tod/;
          next if $value =~ /n\/a/;
          printf "%s.%s.%s %s $time\n", $cfg->val("graphite","basepath"), $hostname, $key, $value if $cfg->val("general","debug") gt 0;
          my $path = $cfg->val("graphite","basepath");
          $sock->send("$path.$hostname.$key $value $time\n") if $cfg->val("general","debug") eq 0;
        }
      }
    }
  }
  $cycle++;
}

sub spinner {
  my $seconds = shift;
  $seconds = $seconds + 12;
  printf "Please wait ~%s seconds\n", $seconds;
  my $i=0;
  my $pid = fork;
  return if $pid;     # in the parent process
  while ($i < $seconds) {
    for (qw[ | / - \ ]) {
      select undef, undef, undef, 0.25;
      printf "\r ($_)";
    }
    $i++;
  }
  exit;  # end child process
}
