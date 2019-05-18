# библиотеки
import seaborn as sns
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as sts

# начали !

a=np.array([2, 8, 0, 4, 1, 9, 9, 0])

# Слайд 4:

sns.countplot(a)

sns.boxplot(a)

sns.scatterplot(range(len(a)),a)
# Слайд 6-11:

np.mean(a)

np.median(a)

np.min(a)
np.max(a)

np.quantile(a,0.25)
np.std(a)
np.var(a)

sts.kurtosis(a)

sts.skew(a)

sts.mode(a)


# Слайд 12-16:



# нормальное распределение


# https://docs.scipy.org/doc/scipy-0.16.1/reference/generated/scipy.stats.norm.html

mu = 2.0
sigma = 0.5

norm_rv = sts.norm(loc=mu, scale=sigma)


x = np.linspace(0,4,100)
pdf = norm_rv.pdf(x)
plt.plot(x, pdf)

plt.ylabel('$f(x)$')
plt.xlabel('$x$')



x = np.linspace(0,4,100)
cdf = norm_rv.cdf(x)
plt.plot(x, cdf)
plt.ylabel('$F(x)$')
plt.xlabel('$x$')


# оценка симметрии
sts.norm(0, 1).cdf(0)


# Правило трех сигм:

sts.norm(0, 1).cdf(1)-sts.norm(0, 1).cdf(-1)



# равномерное распредление


# https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.uniform.html

a = 1
b = 4

uniform_rv = sts.uniform(a, b-a)


x = np.linspace(0,5,100)
cdf = uniform_rv.cdf(x)
plt.plot(x, cdf)

plt.ylabel('$F(x)$')
plt.xlabel('$x$')



x = np.linspace(0,5,1000)
pdf = uniform_rv.pdf(x)
plt.plot(x, pdf)

plt.ylabel('$f(x)$')
plt.xlabel('$x$')


# распределение Бернулли


# https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.bernoulli.html

bernoulli_rv = sts.bernoulli(0.7)

b  =bernoulli_rv.rvs(300)

print(abs(np.sum(b) - 300 * 0.7) / 300)




# биномиальное распределение


# https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.binom.html

binomial_rv = sts.binom(20, 0.9)


x = np.linspace(0,20,21)
cdf = binomial_rv.cdf(x)
plt.step(x, cdf)

plt.ylabel('$F(x)$')
plt.xlabel('$x$')



pmf = binomial_rv.pmf(x)
plt.plot(x, pmf, 'o')

plt.ylabel('$P(X=x)$')
plt.xlabel('$x$')


# распределение Пуассона


# https://docs.scipy.org/doc/scipy-1.1.0/reference/generated/scipy.stats.poisson.html

mu=3
poisson_rv=sts.poisson(mu)


x = np.linspace(0,20,21)
cdf = poisson_rv.cdf(x)
plt.step(x, cdf)

plt.ylabel('$F(x)$')
plt.xlabel('$x$')



pmf = poisson_rv.pmf(x)
plt.plot(x, pmf, 'o')

plt.ylabel('$P(X=x)$')
plt.xlabel('$x$')



# бета распределение


# https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.beta.html

a, b=2.31, 0.627

beta_rv=sts.beta(a, b)


x = np.linspace(0,20,21)
cdf = beta_rv.cdf(x)
plt.step(x, cdf)

plt.ylabel('$F(x)$')
plt.xlabel('$x$')



pdf = beta_rv.pdf(x)
plt.plot(x, pdf, 'o')

plt.ylabel('$P(X=x)$')
plt.xlabel('$x$')