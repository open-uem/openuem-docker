#!/bin/bash
cat << EOF > /etc/nats.cfg
server_name: $SERVER_NAME
listen: ":${NATS_PORT}"

jetstream: enabled

jetstream {
    store_dir: "/var/lib/jetstream/data"
    max_mem: 1G
    max_file: 5G
}

tls {
  cert_file: "/etc/nats-certificates/nats.cer"
  key_file:  "/etc/nats-certificates/nats.key"
  ca_file:   "/etc/nats-certificates/ca.cer"
  verify_and_map: true
  ocsp_peer: true
}

authorization: {  
  users = [
    {user: "CN=OpenUEM Cert-Manager Worker,OU=worker,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: {
      sub: {
        allow: ["_INBOX.>", "certificates.>", "ping.certmanagerworker openuem-cert-manager", "\$JS.API.STREAM.CREATE.>", "\$JS.API.STREAM.UPDATE.>", "\$JS.API.CONSUMER.CREATE.>", "\$JS.API.CONSUMER.MSG.NEXT.>", "\$JS.ACK.>", "\$JS.NACK.>"]
      }
    }},
    {user: "CN=OpenUEM Notification Worker,OU=worker,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: {
      sub: {
        allow: ["_INBOX.>", "notification.>", "ping.notificationworker openuem-notification", "\$JS.API.STREAM.CREATE.>", "\$JS.API.STREAM.UPDATE.>", "\$JS.API.CONSUMER.CREATE.>", "\$JS.API.CONSUMER.MSG.NEXT.>", "\$JS.ACK.>", "\$JS.NACK.>"]
      }
    }},
    {user: "CN=OpenUEM Console,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: {
      publish: ["agent.>", "agentrollback.>", "notification.>", "certificates.>", "ping.>", "server.update.>", "\$JS.API.STREAM.CREATE.>", "\$JS.API.STREAM.UPDATE.>",]
    }},
    {user: "CN=OpenUEM Updater Client,OU=updater,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: {
      sub: {
        allow: ["_INBOX.>", "server.update.>", "\$JS.API.CONSUMER.CREATE.>", "\$JS.API.CONSUMER.MSG.NEXT.>", "\$JS.ACK.>", "\$JS.NACK.>"]
      }
    }},
    {user: "CN=OpenUEM Agent Worker,OU=worker,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: { 
      sub: {
        allow: ["report openuem-agents", "deployresult openuem-agents", "ping.agentworker openuem-agents", "agentconfig openuem-agents", "wingetcfg.> openuem-agents"]
      },
    }},
    {user: "CN=OpenUEM Agent,OU=agent,O=$ORGNAME,POSTALCODE=,STREET=$ORGADDRESS,L=$ORGLOCALITY,ST=$ORGPROVINCE,C=$COUNTRY,", permissions: {
      sub: {
        allow: ["_INBOX.>", "agent.update.>", "agentrollback.>", "agent.certificate", "agent.newconfig", "agent.installpackage.>", "agent.uninstallpackage.>", "agent.updatepackage.>", "agent.enable.>", "agent.disable.>", "agent.report.>", "agent.installpackage.>", "agent.settings.>", "agent.startvnc.> openuem-agent-management", "agent.stopvnc.> openuem-agent-management", "agent.restart.> openuem-agent-management", "agent.poweroff.> openuem-agent-management", "agent.reboot.> openuem-agent-management", "agent.uninstall.> openuem-agent-management" ]
      },
      publish: ["report", "_INBOX.>", "deployresult", "agentconfig", "wingetcfg.>", "\$JS.API.STREAM.INFO.AGENTS_STREAM", "\$JS.API.CONSUMER.CREATE.>", "\$JS.API.CONSUMER.MSG.NEXT.>", "\$JS.ACK.>", "\$JS.NACK.>"]
    }},
  ]
}
EOF