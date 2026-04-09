import {getAuth} from 'firebase-admin/auth';
import * as logger from 'firebase-functions/logger';

interface AuthRequest {
  headers: Record<string, string | string[] | undefined>;
}

interface AuthResponse {
  status(code: number): {
    json(payload: unknown): void;
  };
}

export interface AuthenticatedUser {
  uid: string;
  email: string | null;
}

export async function requireAuthenticatedUser(
  request: AuthRequest,
  response: AuthResponse,
): Promise<AuthenticatedUser | null> {
  const idToken = extractBearerToken(request.headers.authorization);

  if (!idToken) {
    response.status(401).json({
      ok: false,
      error: 'Missing Authorization header. Send Bearer Firebase ID token.',
    });
    return null;
  }

  try {
    const decoded = await getAuth().verifyIdToken(idToken, true);
    return {
      uid: decoded.uid,
      email: decoded.email ?? null,
    };
  } catch (error) {
    logger.warn('ID token verification failed', {error: String(error)});
    response.status(401).json({
      ok: false,
      error: 'Invalid or expired auth token.',
    });
    return null;
  }
}

function extractBearerToken(value: string | string[] | undefined): string | null {
  if (!value) {
    return null;
  }

  const headerValue = Array.isArray(value) ? value[0] ?? '' : value;
  const parts = headerValue.trim().split(' ');

  if (parts.length !== 2) {
    return null;
  }

  if (parts[0].toLowerCase() !== 'bearer') {
    return null;
  }

  const token = parts[1]?.trim() ?? '';
  return token.length === 0 ? null : token;
}
