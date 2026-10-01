# Validation record

On 1 October 2026, this configuration was applied to Google Cloud project `project-7a619bc0-924c-44c4-bab` by its owner. The checks below were run from the local project directory. No credentials or Terraform state are published.

| Check | Result |
| --- | --- |
| Terraform format | Passed (`terraform fmt -check -recursive`) |
| Terraform initialization | Passed; pinned Fabric module v59.0.0, Google providers v8.5.0 |
| Terraform validation | Passed (`Success! The configuration is valid.`) |
| Cloud plan | Passed; 13 resources to add, 0 to change, 0 to destroy |
| Cloud apply | Passed; 13 added, 0 changed, 0 destroyed |
| Post-apply plan | Passed; no changes, no configuration drift |
| Live Google Cloud verification | Two custom-mode VPCs, two subnets with Private Google Access, two IAP-only SSH rules |
| Compute instances | None in the project at verification time |

## Observed live resources

| Environment | VPC | Subnet | Primary CIDR | Private Google Access | IAP SSH rule |
| --- | --- | --- | --- | --- | --- |
| dev | `fabric-demo-dev` | `fabric-demo-dev-europe-west1` | `10.20.0.0/24` | Enabled | `fabric-demo-dev-iap-ssh` |
| prod | `fabric-demo-prod` | `fabric-demo-prod-europe-west1` | `10.30.0.0/24` | Enabled | `fabric-demo-prod-iap-ssh` |

Both firewall rules allow TCP 22 only from `35.235.240.0/20` and only to instances with the `iap-ssh` network tag. No instance was created by this project. The Fabric module also created project routes for Google API access; the detailed route inventory remains visible in Terraform state and Google Cloud.

## Reproduce the checks

```bash
terraform fmt -check -recursive
terraform validate
terraform plan -var="project_id=YOUR_PROJECT_ID" -detailed-exitcode
gcloud compute networks list --project=YOUR_PROJECT_ID --filter="name~^fabric-demo-"
gcloud compute networks subnets list --project=YOUR_PROJECT_ID --filter="name~^fabric-demo-"
gcloud compute firewall-rules list --project=YOUR_PROJECT_ID --filter="name~^fabric-demo-"
```

The no-change plan is valid only against the same local state used for apply. If this repository is cloned elsewhere, a new empty state will propose creating resources; do not apply it to the already deployed project without first migrating/importing state.
