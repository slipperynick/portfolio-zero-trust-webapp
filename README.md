# Zero Trust – Web Application (Security) Stack
*A Zero Trust blueprint for building a modern cloud-native SaaS application on Azure.*

---

## Goal

This project models how I would build the foundations of an example SaaS platform with **Azure**, using open-source and cloud-native security features as much as possible. I created this to see what alternatives exist to the Wiz CNAPP platform. Many of the choices made were used with the combination of security and cost (i.e. free:) in mind.




The design follows **Zero Trust principles**:

- **Verify explicitly**: authenticate every identity, service, and workload.  
- **Use least privilege**: minimize permissions across cloud, cluster, and code.  
- **Assume breach**: add defense-in-depth at every layer.  

---

## Zero Trust Security Layers

Each section below maps to one or more Zero Trust pillars (Identity, Endpoint, Network, Workload, Data, Visibility & Response).

---

### 1. Cloud Security & Governance  
**Zero Trust Pillars: Network, Data**

- Cloud Platform: ***Azure***
  - Logging → *Azure Activity Logs, Monitor, Log Analytics*
  - ✅ Network Segmentation → *Azure NSGs*
  - ✅ Secrets/Certificate Management → *Azure Key Vault*
  - Secure Configuration / Compliance → *Azure Policy (CIS/NIST initiatives)*
  - Web Application Security → *Cloudflare WAF*
  - CSPM → *Prowler for Azure*
  - DDoS Protection → *Cloudflare DDoS*
  - Patch & hygiene management → *Azure Update Manager*
  - (Optional) Defender for SQL/Storage for data-layer protection
  - 🔒💸 (Wish-listed due to cost): Azure Firewall, Azure WAF, Microsoft Defender for Cloud (CSPM + CWPP), Azure DDoS protection

---

### 2. Identity & Access  
**Zero Trust Pillar: Identity**

- Identity Platform: ***Entra ID (Azure AD)***

**Human Access Controls**
- Privileged Identity Management (PIM) for just-in-time admin access  
- Multifactor Authentication (MFA)  
- Conditional Access (CA) for device/location/risk-based logins  
- Identity Protection (risk-based sign-in detection)  
- Passwordless auth (FIDO2/passkeys)

**Workload Identities**
- Entra ID with Workload Identity (OIDC) for AKS pods  
- Managed Identities for VMs and services

**Platform Federation**
- GitHub OIDC → Azure (CI/CD pipelines, secretless)
- ✅ Terraform Cloud OIDC → Azure (IaC pipelines, secretless)

**In-Cluster Authorization**
- Kubernetes RBAC integration (least-privilege roles and bindings)

---

### 3. Kubernetes Cluster Security  
**Zero Trust Pillars: Endpoint (nodes), Network, Runtime**

- Platform: ***Azure Kubernetes Service (AKS)***
  - Private cluster (no public API server)  
  - Separate system vs. user node pools with taints/tolerations  
  - Node auto-upgrade + OS patching enabled  

**Admission & Policy Enforcement**
- Pod Security Admission (baseline / restricted)  
- Kyverno policies (non-root, signed images, approved registries, readOnlyRootFS)  
- Azure Policy for AKS (built-in guardrails)

**Network Security**
- NetworkPolicies with default deny ingress/egress  
- (Optional) Service Mesh (Istio/Linkerd) for fine-grained mTLS and service-to-service policy

**Secrets Management**
- Secret Store CSI Driver + Azure Key Vault integration  
- (Alternative for GitOps) SealedSecrets (kubeseal)

**Runtime Protection**
- Falco (detection) or KubeArmor (enforcement of syscalls, processes, files)

**Compliance & Auditing**
- kube-bench for CIS benchmark scanning  
- Defender for Kubernetes (threat detection, runtime posture management)

---

### 4. CI/CD & SDLC Security  
**Zero Trust Pillars: Identity, Workload**

- IaC: ***Terraform***
  - ✅ Terraform Cloud for state management
  - Terraform IaC scanning with *Trivy* or *Checkov*  or *tfsec*
  - (Optional) Policy-as-code gates (OPA Conftest or Sentinel)

- CI/CD: ***GitHub Actions***
  - ✅ `terraform format` on pull requests  
  - ✅ `checkov` scan on pull requests
  - `tf-plan` on pull requests  
  - `tf-apply` gated on approval  
  - App build/test → scan → sign → deploy  

- GitOps: ***FluxCD***
  - ✅ Sync configured (manifests pulled into cluster)

**Secure SDLC practices**
- Dependency scanning (Dependabot, Trivy)  
- Static analysis (Semgrep, CodeQL)  
- Secret scanning (GitHub Advanced Security)  
- (Optional) Align to SLSA (Supply-chain Levels for Software Artifacts)

- (Optional) terragrunt for DRY multi-environment Terraform

---

### 5. Observability & Response  
**Zero Trust Pillar: Visibility & Analytics**

- SIEM: ***Elastic Cloud SIEM***
- Defender for Cloud: runtime detection, compliance monitoring  
- Metrics & dashboards: Datadog or Prometheus + Grafana  
- Alerts: CrashLoopBackOff, OOMKills, Kyverno admission denials, WAF blocks  
- Threat intel feeds integrated into SIEM (optional)  
- Incident response runbooks defined (optional)  
- SOAR automation for playbooks (optional)

---

### 6. Workload / Application Security  
**Zero Trust Pillar: Workload**

- Supply chain security  
  - Trivy/Grype scanning  
  - SBOM generation (CycloneDX)  
  - Cosign image signing & verification  

- Admission controls  
  - Kyverno verifyImages → only signed workloads deployed  

- In-cluster communication  
  - Optional service mesh (Istio, Linkerd) for mTLS and policy between services  
  - Cert-manager for TLS certificate lifecycle automation  

- API Gateway protections  
  - JWT validation  
  - Rate limiting  
  - WAF integration at ingress for app endpoints  

- Dependency vulnerability management (Dependabot, Trivy)

---

### 7. Developer / Ops Tooling  
*(Not security-critical, but improves operator productivity)*

- **starship** → modern shell prompt with Kubernetes context awareness  
- **kubecolor** → colorized `kubectl` output  
- **k9s** → terminal UI for Kubernetes clusters  
- **rakkess** → RBAC permissions matrix view  
- **kubectl-who-can** → check “who can do X” in RBAC  

---

## Summary

This lab demonstrates how to apply **Zero Trust principles across all pillars** in a modern SaaS platform:  
- **Identity** (Entra ID, RBAC, OIDC federation)  
- **Endpoint** (AKS node hardening, patch management)  
- **Network** (WAF, NetworkPolicies, segmentation)  
- **Workload** (supply chain, signed images, mTLS, API gateway)  
- **Data** (Key Vault, storage encryption)  
- **Visibility & Response** (Defender for Cloud, SIEM, alerts, SOAR)  

