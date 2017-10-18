#Code inspired by https://www.analyticsvidhya.com/blog/2016/03/practical-guide-principal-component-analysis-python/

NormalizedData.pca <- prcomp(~ MMRAcquisitionAuctionAveragePrice+MMRAcquisitionAuctionCleanPrice+MMRAcquisitionRetailAveragePrice+MMRAcquisitonRetailCleanPrice+MMRCurrentAuctionAveragePrice+MMRCurrentAuctionCleanPrice+MMRCurrentRetailAveragePrice+MMRCurrentRetailCleanPrice, NormalizedData[,11:18], cor = TRUE) 
variance <- NormalizedData.pca$sdev^2
plot(cumsum(variance/sum(variance)))
trunc <- NormalizedData.pca$x[,1:3] %*% t(NormalizedData.pca$rotation[,1:3])

if(NormalizedData.pca$scale != FALSE){
  trunc <- scale(trunc, center = FALSE , scale=1/NormalizedData.pca$scale)
}
if(NormalizedData.pca$center != FALSE){
  trunc <- scale(trunc, center = -1 * NormalizedData.pca$center, scale=FALSE)
}

# Both truncated and actual data show same number of components
dim(trunc); dim(NormalizedData[,11:18])
