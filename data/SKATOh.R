#!/opt/R/R-4.2.0/bin/R
SKATOh <- function (obj, G, W.beta = c(1, 25), rho = c(0, 0.1^2, 0.2^2, 0.3^2, 0.4^2, 0.5^2, 0.5, 1))
{   
N = dim(G)[2]
maf = colMeans(G)/2
W = maf^(W.beta[1] - 1) * (1 - maf)^(W.beta[2] - 1)
W = W/sum(W) * N
tmp = t(obj$Ux) %*% G
if (obj$mode == "C") {
        Gs = t(G) %*% G - t(tmp) %*% tmp
        Zs = colSums(obj$U0 * G)/sqrt(obj$s2)
}
else {
        Gs = t(G * obj$Yv) %*% G - t(tmp) %*% tmp
        Zs = colSums(obj$U0 * G)
}
R = t(Gs * W) * W
Z = Zs * W
K = length(rho)
K1 = K
Qs = sum(Z^2)
Qb = sum(Z)^2
Qw = (1 - rho) * Qs + rho * Qb
pval = rep(0, K)
Rs = rowSums(R)
R1 = sum(Rs)
R2 = sum(Rs^2)
R3 = sum(Rs * colSums(R * Rs))
RJ2 = outer(Rs, Rs, "+")/N
if (rho[K] >= 1) {
        K1 = K - 1
        pval[K] = pchisq(Qb/R1, 1, lower.tail = FALSE)
}
Lamk = vector("list", K1)
rho1 = rho[1:K1]
tmp = sqrt(1 - rho1 + N * rho1) - sqrt(1 - rho1)
c1 = sqrt(1 - rho1) * tmp
c2 = tmp^2 * R1/N^2
for (k in 1:K1) {
        mk = (1 - rho[k]) * R + c1[k] * RJ2 + c2[k]
        Lamk[[k]] = pmax(svd(mk, nu = 0, nv = 0)$d, 0)
        pval[k] = SKATR:::KAT.pval(Qw[k], Lamk[[k]])
}
Pmin = min(pval)
qval = rep(0, K1)
for (k in 1:K1) qval[k] = SKATR:::Liu.qval.mod(Pmin, Lamk[[k]])
        lam = pmax(svd(R - outer(Rs, Rs)/R1, nu = 0, nv = 0)$d[-N],
                                                                                   0)
        tauk = (1 - rho1) * R2/R1 + rho1 * R1
        vp2 = 4 * (R3/R1 - R2^2/R1^2)
        MuQ = sum(lam)
        VarQ = sum(lam^2) * 2
        sd1 = sqrt(VarQ)/sqrt(VarQ + vp2)
        if (K1 < K) {
                q1 = qchisq(Pmin, 1, lower = FALSE)
                T0 = Pmin
        } else {
                tmp = (qval - (1 - rho) * MuQ * (1 - sd1)/sd1)/tauk
                q1 = min(tmp)
                T0 = pchisq(q1, 1, lower = FALSE)
        }
        katint = function(xpar) {
        eta1 = sapply(xpar, function(eta0) min((qval - tauk * eta0)/(1 - rho1)))
        x = (eta1 - MuQ) * sd1 + MuQ
        SKATR:::KAT.pval(x, lam) * dchisq(xpar, 1)
}
p.value = try({
        T0 + integrate(katint, 0, q1, subdivisions = 1000, abs.tol = 1e-25)$val
}, silent = TRUE)

prec = 1e-04
#here a "while" was changed with an "if" to avoid infinite loop in some cases
if (class(p.value) == "try-error") {
        p.value = try({
        T0 + integrate(katint, 0, q1, abs.tol = Pmin * prec)$val
        }, silent = TRUE)
        prec = prec * 2
        message(class(p.value))
}

min(p.value, Pmin * K)
}
