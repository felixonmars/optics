-- |
-- Module: Optics.IxAffineTraversal
-- Description: An indexed version of an 'Optics.AffineTraversal.AffineTraversal'.
--
-- An 'IxAffineTraversal' is an indexed version of an
-- 'Optics.AffineTraversal.AffineTraversal'.  See the "Indexed optics" section
-- of the overview documentation in the @Optics@ module of the main @optics@
-- package for more details on indexed optics.
--
module Optics.IxAffineTraversal
  (
  -- * Formation
    IxAffineTraversal
  , IxAffineTraversal'

  -- * Van Laarhoven representation
  , IxAffineTraversalVL
  , IxAffineTraversalVL'
  , ixAtraversalVL
  , toIxAtraversalVL

  -- * Subtyping
  , An_AffineTraversal
  , toIxAffineTraversal

  -- * Re-exports
  , module Optics.Optic
  ) where

import Optics.Internal.Indexed
import Optics.Internal.Optic
import Optics.Internal.Profunctor
import Optics.Optic

-- | Type synonym for a type-modifying indexed affine traversal.
type IxAffineTraversal i s t a b = Optic An_AffineTraversal (WithIx i) s t a b

-- | Type synonym for a type-preserving indexed affine traversal.
type IxAffineTraversal' i s a = Optic' An_AffineTraversal (WithIx i) s a

-- | Type synonym for a type-modifying van Laarhoven indexed affine traversal.
--
-- Note: this isn't exactly van Laarhoven representation as there is
-- no @Pointed@ class (which would be a superclass of 'Applicative'
-- that contains 'pure' but not '<*>'). You can interpret the first
-- argument as a dictionary of @Pointed@ that supplies the @point@
-- function (i.e. the implementation of 'pure').
--
type IxAffineTraversalVL i s t a b =
  forall f. Functor f => (forall r. r -> f r) -> (i -> a -> f b) -> s -> f t

-- | Type synonym for a type-preserving van Laarhoven indexed affine traversal.
type IxAffineTraversalVL' i s a = IxAffineTraversalVL i s s a a

-- | Explicitly cast an optic to an indexed affine traversal.
toIxAffineTraversal
  :: (Is k An_AffineTraversal, is `HasSingleIndex` i)
  => Optic k is s t a b
  -> IxAffineTraversal i s t a b
toIxAffineTraversal = castOptic
{-# INLINE toIxAffineTraversal #-}

-- | Build an indexed affine traversal from the van Laarhoven representation.
ixAtraversalVL :: IxAffineTraversalVL i s t a b -> IxAffineTraversal i s t a b
ixAtraversalVL f = Optic (ivisit f)
{-# INLINE ixAtraversalVL #-}

-- | Convert an indexed affine traversal to its van Laarhoven representation.
toIxAtraversalVL
  :: (Is k An_AffineTraversal, is `HasSingleIndex` i)
  => Optic k is s t a b
  -> IxAffineTraversalVL i s t a b
toIxAtraversalVL o point = \f ->
  runIxStarA (getOptic (toIxAffineTraversal o) (IxStarA point f)) id
{-# INLINE toIxAtraversalVL #-}