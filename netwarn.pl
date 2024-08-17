#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket::INET;
use Getopt::Long;
use Time::HiRes qw(time sleep);
use LWP::UserAgent;
use JSON;

my $RESET         = "\033[0m";
my $GREEN         = "\033[32m";
my $RED           = "\033[31m";
my $BLUE          = "\033[34m";
my $YELLOW        = "\033[33m";
my $MAGENTA       = "\033[35m";
my $CYAN          = "\033[36m";
my $WHITE         = "\033[37m";
my $BLACK         = "\033[30m";
my $BOLD          = "\033[1m";
my $UNDERLINE     = "\033[4m";
my $ITALIC        = "\033[3m";
my $BRIGHT_RED    = "\033[91m";
my $BRIGHT_GREEN  = "\033[92m";
my $BRIGHT_YELLOW = "\033[93m";
my $BRIGHT_BLUE   = "\033[94m";
my $BRIGHT_MAGENTA= "\033[95m";
my $BRIGHT_CYAN   = "\033[96m";
my $BLINK         = "\033[5m";  # Blink text

my %port_descriptions = (
    21    => 'FTP',
    22    => 'SSH',
    23    => 'Telnet',
    25    => 'SMTP',
    53    => 'DNS',
    80    => 'HTTP',
    110   => 'POP3',
    143   => 'IMAP',
    443   => 'HTTPS',
    3306  => 'MySQL',
    3389  => 'RDP',
    8080  => 'HTTP Alternate',
    6379  => 'Redis',
    27017 => 'MongoDB',
    5432  => 'PostgreSQL',
    389   => 'LDAP',
    636   => 'LDAPS',
    1433  => 'MS SQL Server',
    1521  => 'Oracle DB',
    9200  => 'Elasticsearch',
    9300  => 'Elasticsearch Transport',
    11211 => 'Memcached',
);


my @default_ports = keys %port_descriptions;

# Telegram configuration
my $TELEGRAM_BOT_TOKEN = 'Your Telegram Bot Token';
my $TELEGRAM_CHAT_ID   = 'Your Telegram Chat ID';

# Default interval
my $default_interval = 86400;  # 24 hours
my $interval = $default_interval;

# Command-line options
my $single_server;
my $file;
GetOptions(
    's=s' => \$single_server,
    'f=s' => \$file,
    'i=i' => \$interval, 
);

# Function to send a message via Telegram
sub send_telegram_message {
    my ($message) = @_;
    my $ua = LWP::UserAgent->new;
    my $url = "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage";
    my $response = $ua->post(
        $url,
        Content => [
            chat_id => $TELEGRAM_CHAT_ID,
            text    => $message,
            parse_mode => 'HTML',
        ]
    );

    if ($response->is_success) {
        print "${BRIGHT_GREEN}[i] Message sent to Telegram.${RESET}\n";
    } else {
        print "${BRIGHT_RED}Failed to send message: " . $response->status_line . "${RESET}\n";
    }
}

# Convert interval
sub format_interval {
    my ($seconds) = @_;
    my $hours = int($seconds / 3600);
    my $minutes = int(($seconds % 3600) / 60);
    my $seconds_remaining = $seconds % 60;
    return sprintf("%02d hours, %02d minutes, %02d seconds", $hours, $minutes, $seconds_remaining);
}

# Banner
sub print_banner {
    print "${BRIGHT_CYAN}\n";
    print "    
    ╔╗╔┌─┐┌┬┐╦ ╦┌─┐┬─┐┌┐┌
    ║║║├┤  │ ║║║├─┤├┬┘│││
    ╝╚╝└─┘ ┴ ╚╩╝┴ ┴┴└─┘└┘
    \n";
    print "${BRIGHT_YELLOW}                     v0.1${RESET}\n";
    print "${BOLD}${BRIGHT_MAGENTA}       Created by ${BLINK}${UNDERLINE}Lunar Lumos${RESET}\n";
}

#  scan ports
sub scan_ports {
    my ($host, @ports) = @_;
    my @open_ports;

    foreach my $port (@ports) {
        my $socket = IO::Socket::INET->new(
            PeerAddr => $host,
            PeerPort => $port,
            Proto    => 'tcp',
            Timeout  => 1,
        );
        if ($socket) {
            push @open_ports, $port;
            close($socket);
        }
    }
    return @open_ports;
}

# single server
sub scan_server {
    my ($server) = @_;
    print "${BRIGHT_YELLOW}[i] Scanning server: ${BRIGHT_CYAN}$server${RESET}\n";
    my @open_ports = scan_ports($server, @default_ports);

    my $message = "[info] : Scanning server: $server\n";

    if (@open_ports) {
        foreach my $port (@open_ports) {
            my $description = $port_descriptions{$port} // 'Unknown';
            print "${BRIGHT_GREEN}[+] Port ${BRIGHT_CYAN}$port${RESET} (${BRIGHT_MAGENTA}$description${RESET}) is open.\n";
            $message .= "[+] Port $port: $description\n";
        }
    } else {
        print "${BRIGHT_RED}[-] No open ports found on $server.${RESET}\n";
        $message .= "[+] No open ports found.\n";
    }

    send_telegram_message($message);
}

# scan servers file
sub scan_servers_from_file {
    my ($file) = @_;
    open my $fh, '<', $file or die "Cannot open file $file: $!\n";
    my @servers = <$fh>;
    close $fh;

    while (1) {  # continuously scan
        my $start_time = time();
        foreach my $server (@servers) {
            chomp $server;
            scan_server($server);
        }
        my $end_time = time();
        my $elapsed_time = $end_time - $start_time;
        my $remaining_time = $interval - $elapsed_time;

        if ($remaining_time > 0) {
            my $interval_formatted = format_interval($remaining_time);
            my $interval_message = "[+] Next scan in $interval_formatted\n";
            send_telegram_message($interval_message);
            
            print "${BRIGHT_BLUE}[inf] Next scan in ${BRIGHT_YELLOW}$remaining_time${BRIGHT_BLUE} seconds.${RESET}\n";
            sleep($remaining_time);  # Delay before the next scan
        } else {
            print "${BRIGHT_MAGENTA}[i] Re-scanning immediately.${RESET}\n";
        }
    }
}

print_banner();
if ($single_server) {
    scan_server($single_server);
} elsif ($file) {
    scan_servers_from_file($file);
} else {
    die "Please specify either a single server with -s or a file with -f.\n";
}
