Set( $rtname, 'ait.psu.edu');
Set($Organization, "aset.psu.edu");

# We renamed from aset.psu.edu, so match on that or the new name
Set($EmailSubjectTagRegex, qr/(?:aset\.psu\.edu|ait\.psu\.edu)/i);

Set($WebPath, "$ENV{'WEBPATH'}");
Set($WebDomain, "$ENV{'WEBDOMAIN'}");
Set($WebPort, "$ENV{'WEBPORT'}");

Set($DatabaseType, "$ENV{'DBTYPE'}");
Set($DatabaseHost,   "$ENV{'DBHOST'});
Set($DatabaseUser, "$ENV{'DBUSER'}");
Set($DatabasePassword, "$ENV{'DBPASSWORD'}");
Set($DatabaseName, "$ENV{'DBNAME'}");

# Display users as "RealName <EmailAddress>"
Set($UsernameFormat, "verbose");
# Infinite scroll, loads history dynamically
Set($ShowHistory, 'scroll');
Set($HideUnsetFieldsOnDisplay, 1);

Set($MailCommand, "sendmailpipe"); # default
Set($SendmailArguments, "-t -oi -f'rt\@rt.ait.psu.edu'");

# add CCs automatically
Set($ParseNewMessageForTicketCcs, 1);
# we leave this undefined, which causes RT to look at all of the comment and
# correspond addresses configured for every queue
Set($RTAddressRegexp, "(\@rt\.ait\.psu\.edu|\@aitprojects\.aset\.psu\.edu|(aithelp|aitweb|backup|clubsadmin|grouper|dcsaccounts|kerberos|ait-polaris|syseng-linuxreq|syseng-certreq|lpsys|lpintegrations|lpdevelopers|search|storage|trackits|ucshelp|ucsmigration|webrat|win-ad|eio-billing|itab)\@psu\.edu|(hostmaster|pass|sysreq|trackits|trackits-dev|trackits-dev-comment|webrat-dev|webrat-dev-comment)\@(ait|aset)\.psu\.edu|win-ad\@(ait|aset)?\.psu\.edu)");

# only enable this file for debugging purposes
Set($LogToFile, 0);
Set($LogDir, q{var/log});
Set($LogToFileNamed, "rt.log");    

Set($LogToSyslog, 'info');
Set(@LogToSyslogConf, ident => 'RTprod');

#Set($LogToSTDERR, 'info');

Set($WebRemoteUserAuth , 1);
Set($WebRemoteUserAutocreate,1);
Set($WebFallbackToInternalAuth , 1);
Set($WebExternalAuto , 1);

# slight change from default here
Set(%Lifecycles,
    default => {
        initial         => [qw(new)], # loc_qw
        active          => [qw(open wcr stalled)], # loc_qw
        inactive        => [qw(resolved rejected deleted)], # loc_qw

        defaults => {
            on_create => 'new',
            on_merge  => 'resolved',
            approved  => 'open',
            denied    => 'rejected',
            reminder_on_open     => 'open',
            reminder_on_resolve  => 'resolved',
        },

        transitions => {
            ""       => [qw(new open resolved)],

            # from   => [ to list ],
            new      => [qw(    open wcr stalled resolved rejected deleted)],
            open     => [qw(new      wcr stalled resolved rejected deleted)],
            wcr	     => [qw(new open     stalled resolved rejected deleted)],
            stalled  => [qw(new open wcr         rejected resolved deleted)],
            resolved => [qw(new open wcr stalled          rejected deleted)],
            rejected => [qw(new open wcr stalled resolved          deleted)],
            deleted  => [qw(new open wcr stalled rejected resolved        )],
        },
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> *'        => 'ModifyTicket',
        },
        actions => [
            'new -> open'      => { label  => 'Open It', update => 'Respond' }, # loc{label}
            'new -> resolved'  => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'new -> rejected'  => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'new -> deleted'   => { label  => 'Delete',                      }, # loc{label}
            'open -> stalled'  => { label  => 'Stall',   update => 'Comment' }, # loc{label}
            'open -> resolved' => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'open -> rejected' => { label  => 'Reject',  update => 'Respond' }, # loc{label}
	    'open -> wcr'      => { label  => 'Wait on customer', update => 'Comment' },
            'stalled -> open'  => { label  => 'Open It',                     }, # loc{label}
            'resolved -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'rejected -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'deleted -> open'  => { label  => 'Undelete',                    }, # loc{label}
	    'wcr -> resolved'  => { label  => 'Resolve' }
        ],
    },
# don't change lifecyle of the approvals, they are not capable to deal with
# custom statuses
    approvals => {
        initial         => [ 'new' ],
        active          => [ 'open', 'stalled' ],
        inactive        => [ 'resolved', 'rejected', 'deleted' ],

        defaults => {
            on_create => 'new',
            on_merge => 'resolved',
            reminder_on_open     => 'open',
            reminder_on_resolve  => 'resolved',
        },

        transitions => {
            ''       => [qw(new open resolved)],

            # from   => [ to list ],
            new      => [qw(open stalled resolved rejected deleted)],
            open     => [qw(new stalled resolved rejected deleted)],
            stalled  => [qw(new open rejected resolved deleted)],
            resolved => [qw(new open stalled rejected deleted)],
            rejected => [qw(new open stalled resolved deleted)],
            deleted  => [qw(new open stalled rejected resolved)],
        },
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> rejected' => 'ModifyTicket',
            '* -> *'        => 'ModifyTicket',
        },
        actions => [
            'new -> open'      => { label  => 'Open It', update => 'Respond' }, # loc{label}
            'new -> resolved'  => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'new -> rejected'  => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'new -> deleted'   => { label  => 'Delete',                      }, # loc{label}
            'open -> stalled'  => { label  => 'Stall',   update => 'Comment' }, # loc{label}
            'open -> resolved' => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'open -> rejected' => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'stalled -> open'  => { label  => 'Open It',                     }, # loc{label}
            'resolved -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'rejected -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'deleted -> open'  => { label  => 'Undelete',                    }, # loc{label}
        ],
    },
);

# Load plugins
#Set(@Plugins, qw( ));

## Enable unindexed full-text searches
Set(%FullTextSearch,
	Enable  => 1,
	Indexed => 0,
);


##
## RT::Authen::External
##
Set($ExternalInfoPriority, [ 'PSULDAP' ]);
#Set($ExternalAuthPriority, [ '' ]);
Set($ExternalSettings, {
	'PSULDAP' => {
		'type'			=> 'ldap',
		'server'		=> 'dirapps.aset.psu.edu',
		'base'			=> 'dc=psu,dc=edu',
		'filter'		=> '(objectClass=inetOrgPerson)',
		'net_ldap_args'		=> [ version =>  3 ],
		'attr_match_list'	=> [ 'Name', 'EmailAddress' ],
		'attr_map'		=> {
			'Name'			=> 'uid',
			'EmailAddress'		=> 'mail',
			'RealName'		=> 'cn',
			'Gecos'			=> 'uid'
		}
	}
});
Set($AutoCreateNonExternalUsers, 1); # create users in internal database if we couldn't find them


##
## RT::Extension::LDAPImport
##
Set($LDAPHost, "dirapps.aset.psu.edu");
Set($LDAPMapping, {
	Name		=> 'uid',
	EmailAddress	=> 'mail',
	RealName	=> 'cn'
});
#Set($LDAPSizeLimit, 1000);
Set($ExternalAuth, 1); # FIXME: This needs to be set until we upgrade to 4.4.1
Set($LDAPBase, "dc=psu,dc=edu");
Set($LDAPFilter, '(&(objectClass=inetOrgPerson)(objectClass=posixAccount))');
Set($LDAPCreatePrivileged, 1);
Set($LDAPSkipAutogeneratedGroup, 1);
Set($LDAPUpdateUsers, 0);

Set($LDAPGroupBase, 'dc=psu,dc=edu');
#Set($LDAPGroupFilter, '(&(|(cn=umg/up.ais.*)(cn=umg/up.its.*)(cn=umg/staff.up.oas)(cn=umg/its.*)) (&(!(cn=*.admin))(!(cn=*.owner))) (objectClass=groupOfNames) )');
#Set($LDAPGroupFilter, '(& (| (cn=umg/up.ais.*)(cn=umg/staff.up.oas) ) (& (!(cn=*.admin))(!(cn=*.owner)) ) (objectClass=groupOfNames) )');
Set($LDAPGroupFilter, '(& (| (cn=umg/staff.up.oas)(cn=umg/up.ais*)(cn=umg/up.lionpath*)(cn=umg/psu.its*)(cn=umg/up.eio*) ) (& (!(cn=*.admin))(!(cn=*.owner)) ) (objectClass=groupOfNames) )');
Set($LDAPGroupMapping, {
	Name			=> 'cn',
	Member_Attr		=> 'member',
	Member_Attr_Value 	=> 'dn',
	Description		=> sub {
		my %args = @_;
		return 'Synchronized from PSU LDAP group "' . $args{ldap_entry}->dn,
	},
	'GroupCF.PSUgidNumber'	=> 'gidNumber',
	'GroupCF.PSULDAPDN'	=> sub { my %args = @_; return $args{ldap_entry}->dn; },
});
Set($LDAPImportGroupMembers, 1); # import users that are missing when sync'ing groups

1;
