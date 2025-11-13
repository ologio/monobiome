class WLBPosteriorEstimator(PosteriorEstimatorTrainer):
    """
    Weighted likelihood bootstrap (WLB) estimator.

    Trains models to approximate draws from the *weight posterior* (under
    Jeffrey's prior).
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        assert not self.use_non_atomic_loss

    def get_dataloaders(
        self,
        starting_round: int = 0,
        training_batch_size: int = 200,
        validation_fraction: float = 0.1,
        resume_training: bool = False,
        dataloader_kwargs: dict | None = None,
    ) -> tuple[data.DataLoader, data.DataLoader]:
        """
        Add logic for generating session-specific WLB weights.

        This is probably the easiest place to stick some fixed weights on a
        point-wise basis for a given training run, and we load them later where
        we need them in the ``train()`` loop.
        """
        theta, x, prior_masks = self.get_simulations(starting_round)

        # generate session specific WLB weights to attach point-wise
        N = theta.shape[0]
        wlb_z = Exponential(1.0).sample((N,))
        wlb_w = (wlb_z / wlb_z.sum()) * N

        dataset = data.TensorDataset(theta, x, prior_masks, wlb_w)

        num_examples = theta.size(0)
        num_training_examples = int((1 - validation_fraction) * num_examples)
        num_validation_examples = num_examples - num_training_examples

        if not resume_training:
            permuted_indices = torch.randperm(num_examples)
            self.train_indices, self.val_indices = (
                permuted_indices[:num_training_examples],
                permuted_indices[num_training_examples:],
            )

        train_loader_kwargs = {
            "batch_size": min(training_batch_size, num_training_examples),
            "drop_last": True,
            "sampler": SubsetRandomSampler(self.train_indices.tolist()),
        }
        val_loader_kwargs = {
            "batch_size": min(training_batch_size, num_validation_examples),
            "shuffle": False,
            "drop_last": True,
            "sampler": SubsetRandomSampler(self.val_indices.tolist()),
        }
        if dataloader_kwargs is not None:
            train_loader_kwargs = dict(train_loader_kwargs, **dataloader_kwargs)
            val_loader_kwargs = dict(val_loader_kwargs, **dataloader_kwargs)

        train_loader = data.DataLoader(dataset, **train_loader_kwargs)
        val_loader = data.DataLoader(dataset, **val_loader_kwargs)

        return train_loader, val_loader

