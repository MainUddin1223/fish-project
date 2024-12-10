import { NextFunction, Request, Response } from 'express';
import config from '../config';
import { PrismaClient } from '@prisma/client';
import { jwtToken } from './jwtToken';
const prisma = new PrismaClient();

const verifyAuthWithRole = (allowedRoles: string[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization;
    if (!token) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
      const decoded = jwtToken.verifyToken(
        token,
        config.jwt_access_secret as string
      );

      if (!decoded.id) {
        return res.status(401).json({ message: 'Unauthorized' });
      }
      const isExist = await prisma.auth.findUnique({
        where: {
          id: decoded.id,
        },
      });

      if (!isExist || !allowedRoles.includes(isExist?.role) || isExist.is_password_changed) {
        return res.status(401).json({ message: 'Unauthorized' });
      }
      const isPasswordMatched = decoded.secretCode === isExist.password;
      if (!isPasswordMatched) {
        return res.status(401).json({ message: 'Unauthorized' });
      }
      if (isExist?.role == 'supplier') {
        const getSupplier = await prisma.supplierInfo.findFirst({
          where: {
            user_id: isExist?.id
          }
        })
        req.user = {
          id: getSupplier?.id,
          role: isExist.role,
        };
      } else {
        req.user = {
          id: isExist.id,
          role: isExist.role,
        };
      }
      next();
    } catch (error) {
      next(error);
    }
  };
};

const verifyAuth = async (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization;
  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    const decoded = jwtToken.verifyToken(
      token,
      config.jwt_access_secret as string
    );
    if (!decoded.id) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    const isExist = await prisma.auth.findUnique({
      where: {
        id: decoded.id,
      },
    });

    if (!isExist) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    req.user = {
      id: isExist.id,
      role: isExist.role,
    };
    next();
  } catch (error) {
    next(error);
  }
};

const verifyAdmin = verifyAuthWithRole(['admin']);
const verifySupplier = verifyAuthWithRole(['supplier']);
const verifyAdminSupplier = verifyAuthWithRole(['supplier', 'admin']);
const verifyUser = verifyAuthWithRole(['user']);

export {
  verifyAdmin,
  verifySupplier,
  verifyAuth,
  verifyUser,
  verifyAdminSupplier,
};
