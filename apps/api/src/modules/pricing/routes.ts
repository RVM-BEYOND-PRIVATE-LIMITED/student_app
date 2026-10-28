import type { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from 'fastify-type-provider-zod';
import { quoteRequestSchema, quoteResponseSchema } from './schemas.js';
import { quote } from './service.js';
import { InMemoryTeamAppGateway } from '../integrations/gateway.js';

const gateway = new InMemoryTeamAppGateway();

export async function registerPricingRoutes(app: FastifyInstance) {
  app.withTypeProvider<ZodTypeProvider>().post(
    '/v1/pricing/quote',
    { schema: { body: quoteRequestSchema, response: { 200: quoteResponseSchema } } },
    async (req) => {
      // M0: rules from empty set + gateway course check (price source decision pending).
      // Team-app price read happens here once single source is named.
      await gateway.listCourses();
      return quote(req.body, [], new Date());
    },
  );
}
