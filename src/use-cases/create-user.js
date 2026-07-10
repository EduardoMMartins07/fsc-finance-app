import { v4 as uuidv4 } from 'uuid';
import bcrypt from 'bcrypt';

import { PostgresUserRepository } from '../db/postgres/repositories/user-repository.js';

export class CreateUserUseCase {
    async execute(createUserParams) {
        // TODO: verificar se o e-mail já está em uso

        // gerar ID do usuário
        const userId = uuidv4();

        // criptografar a senha do usuário
        const hashedPassword = await bcrypt.hash(createUserParams.password, 10);

        // inserir o usuário no banco de dados
        const user = {
            ...createUserParams,
            id: userId,
            password: hashedPassword,
        };

        // chamar o repositório
        const postgresUserRepository = new PostgresUserRepository();

        const createdUser = await postgresUserRepository.execute(user);

        return createdUser;
    }
}
