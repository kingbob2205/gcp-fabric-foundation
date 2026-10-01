# Architecture and security decisions

## Goal

Provide a small, low-cost foundation that demonstrates infrastructure-as-code, separate environments, private subnet access to Google APIs, and a constrained administration path.

## Design

`dev` and `prod` are separate VPCs in one project. This is useful for a compact demonstration, but production isolation would normally use separate projects (and often folders) with inherited IAM and organization policies. The subnets use different primary and secondary ranges to avoid address overlap if future GKE workloads are added.

The network module comes from Google Cloud Foundation Fabric and is pinned to a release to avoid unexpected upstream changes. The IAP SSH rule does not grant IAM permission to connect; an administrator would still need appropriate IAP and instance access. Since there is no VM, the rule has no current target.

## Security boundaries and omissions

- Ingress: no public SSH range such as `0.0.0.0/0` is allowed. Only the documented IAP range may reach tagged instances on TCP 22.
- Egress: Google Cloud's implied allow-egress rule still applies. This project does **not** implement a deny-egress policy or VPC Service Controls.
- Identity: no user, service-account key, or broad project IAM role is created. Access to the project is a prerequisite, not something this demo grants.
- State: local state is acceptable for solo demonstration, but not for production collaboration. A production follow-up should use protected remote state.
- Cost: no running compute is deployed. Future workloads, traffic, and logging may still generate charges.

## Interview explanation

The decisive requirement is a reproducible foundation, not an application workload. Terraform defines desired state, the pinned Fabric module encapsulates VPC/subnet resources, and environment separation reduces accidental coupling. The IAP-only SSH rule shows a narrower management path without exposing port 22 to the Internet. This is deliberately scoped to a project because an organization-wide FAST landing zone needs org-admin and billing-admin access.

